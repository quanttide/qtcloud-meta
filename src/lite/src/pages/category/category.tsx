import { View, Text } from '@tarojs/components'
import { useLoad } from '@tarojs/taro'
import { statement, procedural, ungridded, type Grid } from '@/data/category'
import './category.scss'

function GridTable ({ grid }: { grid: Grid }) {
  return (
    <View className='cat__grid'>
      <View className='cat__grid-head'>
        <Text className='cat__grid-title'>{grid.title}</Text>
        <Text className='cat__grid-dims'>{grid.rowDim} × {grid.colDim}</Text>
      </View>
      <View className='cat__row cat__row--header'>
        <View className='cat__corner' />
        {grid.cols.map((col) => (
          <View key={col} className='cat__cell cat__cell--col'>
            <Text className='cat__col-label'>{col}</Text>
          </View>
        ))}
      </View>
      {grid.rows.map((row, r) => (
        <View key={row} className='cat__row'>
          <View className='cat__corner'>
            <Text className='cat__row-label'>{row}</Text>
          </View>
          {grid.cells[r].map((cell) => (
            <View key={cell.name} className='cat__cell'>
              <Text className='cat__cell-name'>{cell.name}</Text>
              <Text className='cat__cell-label'>{cell.label}</Text>
            </View>
          ))}
        </View>
      ))}
    </View>
  )
}

export default function Category () {
  useLoad(() => {
    console.log('Category loaded.')
  })

  return (
    <View className='cat'>
      <Text className='cat__intro'>
        标准范畴 = 两个九宫格 18 格 + Context、Archive 两种不占格资产。
        正本：《量潮标准范畴》。
      </Text>

      <GridTable grid={statement} />
      <GridTable grid={procedural} />

      <View className='cat__ungridded'>
        <Text className='cat__grid-title'>不占格</Text>
        {ungridded.map(({ cell, role }) => (
          <View key={cell.name} className='cat__ungridded-card'>
            <View className='cat__ungridded-name'>
              <Text className='cat__cell-name'>{cell.name}</Text>
              <Text className='cat__cell-label'>{cell.label}</Text>
            </View>
            <Text className='cat__ungridded-role'>{role}</Text>
          </View>
        ))}
      </View>
    </View>
  )
}
