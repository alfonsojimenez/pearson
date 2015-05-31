module Pearson
  class << self
    # Calculates the pearson correlation coefficient between
    # two entities
    #
    # @param [Hash] Hash containing entity-item scores
    # @param [String] First entity
    # @param [String] Second entity
    #
    # @return [Float] Coefficient
    def coefficient(scores, entity1, entity2)
      shared_items = shared_items(scores, entity1, entity2)

      n = shared_items.length

      return 0 if n == 0

      sum1 = sum2 = sum1_sq = sum2_sq = psum = 0

      shared_items.each_key do |item|
        sum1 += scores[entity1][item].to_f
        sum2 += scores[entity2][item].to_f

        sum1_sq += scores[entity1][item].to_f**2
        sum2_sq += scores[entity2][item].to_f**2

        psum += scores[entity1][item].to_f*scores[entity2][item].to_f
      end

      num = psum - (sum1*sum2/n)
      den = ((sum1_sq - (sum1**2)/n) * (sum2_sq - (sum2**2)/n)) ** 0.5

      den == 0 ? 0 : num/den
    end

    # Returns the closest entities from a given entity. The distance
    # between entities is based on the Pearson correlation coefficient
    #
    # @param [Hash] Hash containing entity-item scores
    # @param [String] Entity
    # @param [Hash] Options (limit)
    #
    # @return [Array] Top matches
    def closest_entities(scores, entity, opts={})
      sort_desc(scores, opts) do |h, k, v|
        entity == k ? h : h.merge(k => coefficient(scores, entity, k))
      end 
    end

    # Returns the best recommended items for a given entity
    #
    # @param [Hash] Hash containing entity-item scores
    # @param [String] Entity
    # @param [Hash] Options (limit)
    #
    # @return [Array] Top matches [item, score]
    def recommendations(scores, entity, opts={})
      totals = {}
      similarity_sums = {}

      totals.default = 0
      similarity_sums.default = 0

      fail EntityNotFound unless scores[entity]

      scores.each do |other_entity|
        next if other_entity.first == entity

        similarity = coefficient(scores, entity, other_entity.first)

        next if similarity <= 0

        scores[other_entity.first].each do |item, score|
          if !scores[entity].keys.include?(item) || scores[entity][item] == 0
            totals[item] += score * similarity
            similarity_sums[item] += similarity
          end
        end
      end

      sort_desc(totals, opts) {|h, k, v| h.merge(k => v/similarity_sums[k]) }
    end

    private

    # Returns a hash containing the shared items between two different entities
    #
    # @param [Hash] Hash containing entity-item scores
    # @param [String] Entity
    # @param [String] Entity
    #
    # @return [Hash] Common items
    def shared_items(scores, entity1, entity2)
      Hash[*(scores[entity1].keys & scores[entity2].keys).flat_map{|k| [k, 1]}]
    end

    def sort_desc(results, opts={})
      limit = opts[:limit] || 3

      results.reduce({}) do |h, (k, v)|
        yield(h, k, v)
      end.sort_by{|k, v| v}.reverse[0..(opts[:limit] || 3)-1]
    end
  end

  class EntityNotFound < StandardError; end
end

