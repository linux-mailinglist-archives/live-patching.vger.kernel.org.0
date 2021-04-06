Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF14435517A
	for <lists+live-patching@lfdr.de>; Tue,  6 Apr 2021 13:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhDFLDW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 6 Apr 2021 07:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhDFLDV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 6 Apr 2021 07:03:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B924061055;
        Tue,  6 Apr 2021 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617706994;
        bh=feVSVdneCF5Z0KFs4Mc8lgfRu23TV0mL2jYYWxBzMlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YuHT14mRco+dzf70WdkLcOIVfVU6oRTuJUkJYNQ3yDpzV3w9zWyIAePREROqXP6tX
         WqJISse0+m/zI5QwVFK2OzII7oNMSc1ql0Skhr//j7lrkm66itj07bByKbRnQONmJs
         wYHSqnS+JQAdHOut5WOhMx0KPdLTxlrjh9e3h1XciknW7U/dNdZUslegOhJah+J4l4
         YSTsXTxPiLjrZVet0GBpjxQCoubxSPx745DQXo6Sm00NC4axz6ZBcYTihpxW4iM7K3
         Wl3lL1icBZlAAodB0V/0PmIc6DuvwZu0lkBkDF/+D065Y7kHCnUQ4QAdQYoXfDK45q
         9zH8MTmlOjugA==
Date:   Tue, 6 Apr 2021 12:02:57 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the
 stack trace unreliable
Message-ID: <20210406110257.GA6443@sirena.org.uk>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-4-madvenka@linux.microsoft.com>
 <20210401142759.GJ4758@sirena.org.uk>
 <0bece48b-5fee-2bd1-752e-66d2b89cc5ad@linux.microsoft.com>
 <20210401182810.GO4758@sirena.org.uk>
 <2a56fe4b-9929-0d8b-aa49-c2b1c1b82b79@linux.microsoft.com>
 <fe2f3b1e-8cb6-05ce-7968-216fed079fe4@linux.microsoft.com>
 <9ebc341b-ba5a-db9a-c5e6-17b30d4b1fd4@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <9ebc341b-ba5a-db9a-c5e6-17b30d4b1fd4@linux.microsoft.com>
X-Cookie: BARBARA STANWYCK makes me nervous!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 01, 2021 at 02:47:11PM -0500, Madhavan T. Venkataraman wrote:
> On 4/1/21 1:53 PM, Madhavan T. Venkataraman wrote:

> > Alternatively, I could just move the SYM_INNER_LABEL(ftrace_graph_call..) to outside the ifdef.

> Or, even better, I could just use ftrace_call+4 because that would be the return
> address for the tracer function at ftrace_call:

> I think that would be cleaner. And, I don't need the complicated comments for ftrace_graph_call.

> Is this acceptable?

I think either of those should be fine.

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBsP+AACgkQJNaLcl1U
h9BAFwf7BcZKDmVjMobAlViTRTdrDIK11ry9Bg03OuKs5Ckpvl/iJqqi2JWu9P1Z
Opj4gyGT1rGfThM8p8K03l+97zuQV7E7xD2MavLAkEQtR+DlOZ4b7stYtERSxgKL
YkCRAGaQUFyOK6b7xAz64PW/i23MJ+1llUFGJNdxC+7akNAuvuUF+MX/TU0k82f9
1KT+yQ1OwoCzyaGVHi4Cy+hormWNWDZBGwHg0MvSiPLw4taL7iyHnheB+LWUgA9r
umqZnlMU9itzdWF0UR+iBH+vzeMlgWyV9jQk5WR0LxCCIxrhXv0WKQAAAjQxOW3I
2Ly7um10NjRbLJ2kUCZ/TSYW5GI98w==
=xD66
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
