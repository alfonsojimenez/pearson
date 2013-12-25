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
        sum1 += scores[entity1][item]
        sum2 += scores[entity2][item]

        sum1_sq += scores[entity1][item]**2
        sum2_sq += scores[entity2][item]**2

        psum += scores[entity1][item]*scores[entity2][item]
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
    def recommendations(scores, person, opts={})
      totals = {}
      similaritySums = {}

      totals.default = 0
      similaritySums.default = 0

      fail PersonNotFound unless scores[person]

      scores.each do |other_person|
        next if other_person.first == person

        similarity = coefficient(scores, person, other_person.first)

        next if similarity <= 0

        scores[other_person.first].each do |item, score|
          if !scores[person].keys.include?(item) || scores[person][item] == 0
            totals[item] += score * similarity
            similaritySums[item] += similarity
          end
        end
      end

      sort_desc(totals, opts) {|h, k, v| h.merge(k => v/similaritySums[k]) }
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

  class PersonNotFound < StandardError; end
end

