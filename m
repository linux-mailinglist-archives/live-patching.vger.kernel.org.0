Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA539E4AB
	for <lists+live-patching@lfdr.de>; Mon,  7 Jun 2021 19:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGREC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Jun 2021 13:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230242AbhFGREC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Jun 2021 13:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6762960FEF;
        Mon,  7 Jun 2021 17:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623085331;
        bh=NUBegMkHMRU0efBpVXAEVuvKfOjguw4pIRnAwazn6bU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EtnJIyYwNslqxRzpJaVTW6zcxGkq6HC7UFWBECKb8Z+IJ+qvsnv3mMtH9//n7AKX0
         9ALilcqD0jjPz1LGnfUiYxT3m/TBKsJA58alYT+5VnWwugt/qf00KpkA1gyrHKFULM
         3b8sBrVmLa0U6RFx/FoeqlL9b1s2NkGyJviX6DYhOPPUlFJbQOP+EC27pm86vp+LKS
         14SKfUGRe6quUqAQYQXLJYQRGEsBSYi0mc6e3LcdzzVuTQ3JQ2OhWWHp/q/tNGOcCa
         cI1FGINYLeLPHQ6rmaU2g6W+LwCxSa0+p3Uo8mtGZ9QMEh7WjkaIYWZQLya2a6aGp+
         dFzM9XzsW5ZNA==
Date:   Mon, 7 Jun 2021 18:01:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, catalin.marinas@arm.com,
        will@kernel.org, mark.rutland@arm.com,
        madvenka@linux.microsoft.com, duwe@lst.de,
        sjitindarsingh@gmail.com, benh@kernel.crashing.org
Subject: Re: [RFC PATCH 1/1] arm64: implement live patching
Message-ID: <20210607170154.GC10625@sirena.org.uk>
References: <20210604235930.603-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <20210604235930.603-1-surajjs@amazon.com>
X-Cookie: I never did it that way before.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 04, 2021 at 04:59:30PM -0700, Suraj Jitindar Singh wrote:

> + * CONFIG_ARM64_BTI_KERNEL:
> + *	- Inserts a hint #0x22 on function entry if the function is called
> + *	  indirectly (to satisfy BTI requirements), which is inserted before
> + *	  the two nops from above.

Please write out the symbolic name of the HINT (BTI C here) rather than
the number, it helps with readability especially in a case like this
where there are multiple relevant hints.

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmC+UQIACgkQJNaLcl1U
h9Dw0Af9Fck3O7T1Cap/Vuk6PkvHxnQ4xCF728tOGwzHZ+CuIr2ormUC6vMhp0Lp
nGOJn/yJ9wzKy/murvphmhJ94w/Ybw4eabvZY0PDuMc0bMkVwC+EpwNYU+FwhWXf
zrIVFIYZ8OfsmdUXpP+jsHOz7kaNToEV5OD0uk0384HGtcMea8rY33CxRVHHrjMM
2gvvSwmZiQQx0M9wWF/6wxjDZXWZsc3WyBZGktjrbSG2PK0t54tGaYE8Baf5dG9p
FOTF8cts8/lqRUi84svY6uQh+1LvMggLLBDDEegxqnKmiDE9sHc+5WnTWsI3QzkT
EpojB1GptMHvP35LNXIAPGjhqZsMkQ==
=YC3F
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
