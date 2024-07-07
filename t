private static Map convertLazyMapToHashMap(def json) {
        if (json instanceof Map) {
            def hashMap = new HashMap()
            json.each { key, value ->
                hashMap[key] = convertLazyMapToHashMap(value)
            }
            return hashMap
        } else if (json instanceof List) {
            def list = []
            json.each { item ->
                list << convertLazyMapToHashMap(item)
            }
            return list
        } else {
            return json
        }
    }
