//
//  PreviewMockData.swift
//  QueueingSample
//
//  Created by Dave Becker on 10/9/23.
//

import Foundation
import AccessoQueueing

enum MockQueueingData {
    static func attractions() -> [Attraction] {
        do {
            return try JSONDecoder().decode([Attraction].self, from: attractionsData)
        } catch {
            return []
        }
    }

    static func attraction() -> Attraction? {
        do {
            return try JSONDecoder().decode(Attraction.self, from: attractionData)
        } catch {
            return nil
        }
    }

    static let attractionData: Data = Data("""
          {
            "name": "Attraction Name",
            "description": "description",
            "restrictions": [
              "restrictions",
              "restrictions"
            ],
            "id": "id",
            "state": "state",
            "waitTimeInMinutes": 0.8008282,
            "thumbnailImage": "thumbnailImage",
            "reserveActions": [
              {
                "data": {
                  "key": ""
                },
                "description": "description",
                "id": "id",
                "inputRequirements": [
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  },
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  }
                ]
              },
              {
                "data": {
                  "key": ""
                },
                "description": "description",
                "id": "id",
                "inputRequirements": [
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  },
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  }
                ]
              }
            ]
          }
        """.utf8)

    static let attractionsData: Data = Data("""
        [
          {
            "name": "Attraction Name",
            "description": "description",
            "restrictions": [
              "restrictions",
              "restrictions"
            ],
            "id": "id",
            "state": "state",
            "waitTimeInMinutes": 0.8008282,
            "thumbnailImage": "https://media.istockphoto.com/id/1183916666/vector/red-dragon-head-digital-painting.jpg?s=612x612&w=0&k=20&c=dDu6vxNhL1zkXyXdLh0_AWqoysJPY43idokKFvknOaA=",
            "reserveActions": [
              {
                "data": {
                  "key": ""
                },
                "description": "description",
                "id": "id",
                "inputRequirements": [
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  },
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  }
                ]
              },
              {
                "data": {
                  "key": ""
                },
                "description": "description",
                "id": "id",
                "inputRequirements": [
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  },
                  {
                    "isRequired": true,
                    "defaultValue": 6,
                    "dataType": "dataType",
                    "description": "description",
                    "maximum": 5,
                    "id": "id",
                    "title": "title",
                    "minimum": 1
                  }
                ]
              }
            ]
          }
        ]
        """.utf8)
}
