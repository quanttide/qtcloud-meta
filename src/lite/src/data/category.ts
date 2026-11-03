/**
 * 标准范畴数据：正本是元工程案例集的《量潮标准范畴》
 * （quanttide-meta/docs/gallery/metaphysics/category/index.md）。
 * 这里是它的只读摘录——两个九宫格 18 格 + Context、Archive 两种不占格资产。
 * 正本改了，这里随改。
 */

export interface Cell {
  /** 英文名，进报告与文件名 */
  name: string
  /** 中文名 */
  label: string
}

export interface Grid {
  title: string
  /** 行维度名 */
  rowDim: string
  /** 列维度名 */
  colDim: string
  rows: string[]
  cols: string[]
  /** 与 rows 同序，每行与 cols 同序 */
  cells: Cell[][]
}

/** 陈述型记忆：类型 × 时间，回答「知道什么」 */
export const statement: Grid = {
  title: '陈述型记忆',
  rowDim: '时间',
  colDim: '类型',
  rows: ['过去', '现在', '未来'],
  cols: ['事件类', '语义类', '自我类'],
  cells: [
    [
      { name: 'Report', label: '报告' },
      { name: 'Library', label: '图书馆' },
      { name: 'History', label: '历史' }
    ],
    [
      { name: 'Journal', label: '日志' },
      { name: 'Profile', label: '档案' },
      { name: 'Brochure', label: '宣传册' }
    ],
    [
      { name: 'Roadmap', label: '路线图' },
      { name: 'Insight', label: '洞察' },
      { name: 'Intention', label: '愿景' }
    ]
  ]
}

/** 程序型记忆：约束力 × 消费对象，回答「怎么做事」 */
export const procedural: Grid = {
  title: '程序型记忆',
  rowDim: '约束力',
  colDim: '消费对象',
  rows: ['宪法', '法律', '法理'],
  cols: ['规则', '建模', '应用'],
  cells: [
    [
      { name: 'Bylaw', label: '章程' },
      { name: 'Specification', label: '工程标准' },
      { name: 'Toolkit', label: '标准库' }
    ],
    [
      { name: 'Handbook', label: '手册' },
      { name: 'Gallery', label: '案例' },
      { name: 'Platform', label: '平台' }
    ],
    [
      { name: 'Tutorial', label: '教程' },
      { name: 'Essay', label: '论文' },
      { name: 'Laboratory', label: '实验室' }
    ]
  ]
}

/** 不占格的两种：入口与出口 */
export const ungridded: { cell: Cell; role: string }[] = [
  { cell: { name: 'Context', label: '上下文' }, role: '九宫格的默认入口：观察与约束从这里进入' },
  { cell: { name: 'Archive', label: '归档' }, role: '过时资产的备份出口：持久化存储与可追溯' }
]
