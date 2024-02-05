<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\ArtistCollection;
use App\Models\Artist;
use Illuminate\Http\Request;
use Spatie\QueryBuilder\AllowedFilter;
use Spatie\QueryBuilder\Exceptions\InvalidFilterQuery;
use Spatie\QueryBuilder\QueryBuilder;

class ArtistsController extends Controller
{
    /**
     * Response with filtered artists data
     *
     * @route /api/artists
     * @return ArtistCollection
     */
    public function handle(): ArtistCollection
    {
        return new ArtistCollection(
            QueryBuilder::for(\App\Models\Artist::class)
                ->allowedFilters([
                    'email',
                    AllowedFilter::scope('active')->nullable(),
                    AllowedFilter::scope('inactive')->nullable(),
                ])
                ->paginate(100)
        );
    }
}
