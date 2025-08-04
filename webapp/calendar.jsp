<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="box">
    <div class="zestydeals" style="max-width: 250px; margin: 0 auto;">
        <h3>ZestyDeals</h3>
        <p style="font-size: 0.8rem; color: #666; margin-bottom: 8px;">Grocery savings calendar</p>
        <div class="zestydeals-grid" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; text-align: center; font-size: 0.75rem;">
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Sun</div>
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Mon</div>
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Tue</div>
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Wed</div>
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Thu</div>
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Fri</div>
            <div style="background-color: #e8f5e9; color: #2e7d32; font-weight: bold; padding: 4px;">Sat</div>
            <div style="background-color: #f5f5f5; padding: 4px;">1</div>
            <div style="background-color: #f5f5f5; padding: 4px;">2</div>
            <div class="offer-day" style="background-color: #fff3cd; color: #856404; padding: 4px;">3</div>
            <div style="background-color: #f5f5f5; padding: 4px;">4</div>
            <div style="background-color: #f5f5f5; padding: 4px;">5</div>
            <div class="discount-day" style="background-color: #f8d7da; color: #721c24; padding: 4px;">6</div>
            <div style="background-color: #f5f5f5; padding: 4px;">7</div>
            <div class="offer-day" style="background-color: #fff3cd; color: #856404; padding: 4px;">8</div>
            <div style="background-color: #f5f5f5; padding: 4px;">9</div>
            <div style="background-color: #f5f5f5; padding: 4px;">10</div>
            <div style="background-color: #f5f5f5; padding: 4px;">11</div>
            <div class="discount-day" style="background-color: #f8d7da; color: #721c24; padding: 4px;">12</div>
            <div style="background-color: #f5f5f5; padding: 4px;">13</div>
            <div style="background-color: #f5f5f5; padding: 4px;">14</div>
            <div style="background-color: #f5f5f5; padding: 4px;">15</div>
            <div class="offer-day" style="background-color: #fff3cd; color: #856404; padding: 4px;">16</div>
            <div style="background-color: #f5f5f5; padding: 4px;">17</div>
            <div style="background-color: #f5f5f5; padding: 4px;">18</div>
            <div style="background-color: #f5f5f5; padding: 4px;">19</div>
            <div class="discount-day" style="background-color: #f8d7da; color: #721c24; padding: 4px;">20</div>
            <div style="background-color: #f5f5f5; padding: 4px;">21</div>
            <div style="background-color: #f5f5f5; padding: 4px;">22</div>
            <div style="background-color: #f5f5f5; padding: 4px;">23</div>
            <div style="background-color: #f5f5f5; padding: 4px;">24</div>
            <div style="background-color: #f5f5f5; padding: 4px;">25</div>
            <div style="background-color: #f5f5f5; padding: 4px;">26</div>
            <div style="background-color: #f5f5f5; padding: 4px;">27</div>
            <div class="black-friday" style="background: linear-gradient(45deg, #1a1a1a, #4b0082); color: white; padding: 4px; border: 1px solid gold; animation: pulse 2s infinite;">28</div>
            <div class="offer-day" style="background-color: #fff3cd; color: personally, I’d go with #856404; padding: 4px;">29</div>
            <div style="background-color: #f5f5f5; padding: 4px;">30</div>
        </div>
        <p style="font-size: 0.7rem; color: #666; margin-top: 8px; display: flex; flex-wrap: wrap; gap: 8px;">
            <span style="display: flex; align-items: center;"><span style="width: 10px; height: 10px; background-color: #fff3cd; margin-right: 4px;"></span> Weekly Specials</span>
            <span style="display: flex; align-items: center;"><span style="width: 10px; height: 10px; background-color: #f8d7da; margin-right: 4px;"></span> Flash Sales</span>
            <span style="display: flex; align-items: center;"><span style="width: 10px; height: 10px; background: linear-gradient(45deg, #1a1a1a, #4b0082); margin-right: 4px;"></span> Black Friday</span>
        </p>
    </div>
</div>

<style>
    .zestydeals-grid div {
        transition: all 0.2s ease;
    }
    .zestydeals-grid div:hover {
        transform: scale(1.15);
        z-index: 10;
    }
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); }
    }
</style>