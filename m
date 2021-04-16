Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B4E362412
	for <lists+live-patching@lfdr.de>; Fri, 16 Apr 2021 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343719AbhDPPg6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Apr 2021 11:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245739AbhDPPg5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Apr 2021 11:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A4C5610CD;
        Fri, 16 Apr 2021 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618587393;
        bh=NKNA2z1fe3i+RmY3wY7HLCQFQeUUmgc/v5LkxYsgfWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uvssamVWhWsvWsVH4mxNyzQz0l4unazpuTdcXWQvuxcrgJ78fHI4UWGIk9UtodV/f
         NSp824oWOKyT8b0InPvjE/Xcbs+YaTM9l5Sfd/iigUNGYljzF7PRDMAOARVLLXy8VB
         NW3VfvZEuRogMWx+qYzN6aaVucduyW/CkeJ0zab91zC3pScTDNWOYc1LGfJXJgCYdF
         igjT6PK8uMO6e8NE6NQKH1FYh4fdHhknYtEw3bSwNlM5coErJKjoNm69tclPMC0RCn
         PJifGs4M8Xh64H2mtYC5aDAOhOTsUBdatdGyrdVwltWLQnds0nC8xoZne0yXrsVDtZ
         30lSA3M3glyaw==
Date:   Fri, 16 Apr 2021 16:36:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210416153608.GD5560@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <20210412173617.GE5379@sirena.org.uk>
 <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
 <20210413110255.GB5586@sirena.org.uk>
 <714e748c-bb79-aa9a-abb5-cf5e677e847b@linux.microsoft.com>
 <e8367fe9-6fd0-f962-422d-daa4548cc3b7@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <e8367fe9-6fd0-f962-422d-daa4548cc3b7@linux.microsoft.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 16, 2021 at 09:43:48AM -0500, Madhavan T. Venkataraman wrote:

> How would you prefer I handle this? Should I place all SYM_CODE functions that
> are actually safe for the unwinder in a separate section? I could just take
> some approach and solve this. But I would like to get your opinion and Mark
> Rutland's opinion so we are all on the same page.

That sounds reasonable to me, obviously we'd have to look at how
exactly the annotation ends up getting done and general bikeshed colour
discussions.  I'm not sure if we want a specific "safe for unwinder
section" or to split things up into sections per reason things are safe
for the unwinder (kind of like what you were proposing for flagging
things as a problem), that might end up being useful for other things at
some point.

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB5rugACgkQJNaLcl1U
h9DWgQf9FG0/kc0HYV3uoE2g+LO4VYETzadCuvDsP2FO0f+CLwoFVZykfaYD/14p
5UObg6hOHtLtT3fVfA39EFPMR/MRYPAdzZiV+Qodl5c0Qh1t8go/aa4V4DOtru+z
FLRUipOPb34+JkiHPzgY7rQWCraRE0kTE57jA3qPPNCcHwjyEcNFTRUggLS3hvPR
oIUr7ns/X8YvlhA6CoL6CkiBTl1izIuHqvJEIjThBQXsuMrbAz8kyTYzMYStktk1
Egm77OL9g8U1qpEiozK5F1qGm77kqairQekA6Ip5+wu2D07lxUIe6QtTw2msNB3z
gllfQVW9aIvW86kYNMUDXh1VO+OSdQ==
=zhTJ
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
