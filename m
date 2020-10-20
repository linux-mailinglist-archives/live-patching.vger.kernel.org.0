Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80B5293FAE
	for <lists+live-patching@lfdr.de>; Tue, 20 Oct 2020 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436568AbgJTPjZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Oct 2020 11:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436565AbgJTPjY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Oct 2020 11:39:24 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C036E22247;
        Tue, 20 Oct 2020 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603208364;
        bh=WvtM8lVaUa9n6kZloXHDYcS2/S2PuIPyjBhGUcDqflY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPjk0IxpAocgXvARJKZOOuIGehhrmFemg8rN4u9fTXs2wwwyemw8hkA9kRoVLeIph
         x9zy9WVniBFdOd/Emr0Jq65uVh309hgoVspwKsB9nXq0vUPYhJ0Yq0l1l8yYyHlWXe
         zPAos9Mih8+/PEJYiMHT8Jwhl5x68Dj3KKloyXY4=
Date:   Tue, 20 Oct 2020 16:39:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201020153913.GE9448@sirena.org.uk>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
 <20201015212931.mh4a5jt7pxqlzxsg@treble>
 <20201016121534.GC5274@sirena.org.uk>
 <20201019234155.q26jkm22fhnnztiw@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <20201019234155.q26jkm22fhnnztiw@treble>
X-Cookie: The people rule.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 19, 2020 at 06:41:55PM -0500, Josh Poimboeuf wrote:
> On Fri, Oct 16, 2020 at 01:15:34PM +0100, Mark Brown wrote:

> > Ah, I'd have interpreted "defined thread entry point" as meaning
> > expecting to find specific functions appering at the end of the stack
> > rather than meaning positively identifying the end of the stack - for
> > arm64 we use a NULL frame pointer to indicate this in all situations.
> > In that case that's one bit that is already clear.

> I think a NULL frame pointer isn't going to be robust enough.  For
> example NULL could easily be introduced by a corrupt stack, or by asm
> frame pointer misuse.

Is it just the particular poison value that you're concerned about here
or are you looking for additional checks of some other kind?

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+PBKAACgkQJNaLcl1U
h9CmCQf9GADeXb4clrrWKiZ2FKpp7qztSVT7TN33f+79sG5oc8MkFcPkif5Mc6bk
tpBrddZNh2aI+uGg3RGCYWBE5S9LM3zE7SSin+1YkZWQ7O7/X7XK2WjJUTJS9qqR
HB781+Hf1SfbuO4Hss1fb/hDVPt4v0Qy907v9FKF3f8V9twBclG+rQhYFFMY9DmP
yFN0MGtXsDxjLUqbx76qRhtuOgMtnGIOq+4vR9fvt71fwyPcJdnk8nV2GXA02wdj
y5ZKT1gKOTozCnKj3yWMbvWCVqAQYRmTWwEPiRSrNmJ9smjxULVhs0nOzt4BcS5+
cs2VAofO7555YCEKG90qYd8obAj83A==
=SRXS
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
