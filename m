Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DD435CF0A
	for <lists+live-patching@lfdr.de>; Mon, 12 Apr 2021 19:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244350AbhDLRBO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Apr 2021 13:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244004AbhDLRAN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Apr 2021 13:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 138A36023C;
        Mon, 12 Apr 2021 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618246793;
        bh=BQycS0ErGs1iBx+gONK+Cmo+KhJHO+nr3dZiwSHZ1H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gIO+h/h2Eee2A9ixqvwzRwQpJMoYHOugv0n5s0CqtQCLii4NmeeMd95x0MDE5NQw8
         cF0RIi0+hT/5IS9E9kKkIvv4PlZFAl3EH52UKP8xtCzF/Z86KV/Bs7dPx1WDjOYTCO
         31XIEj7v0tCS/kgaRWS+6eUR0ARpgv/3x6awTpeTv4eYSYLOdp/jRzJbt0Qq1k63ll
         TesUn6WaSbAi9sdjNK2iEo8h0Dxyaxt/ZJsnOxA1iKqNomCoMsHS779/Vvid7Gbxgk
         cfO5f9MkLr1Nf7KtPrWfpKjDBWAcB9Bnw3M5Kuu0I4p1Fbljom0BLQdv+WNO4D5T2E
         MM7BIbfDYOjoQ==
Date:   Mon, 12 Apr 2021 17:59:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210412165933.GD5379@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
 <20210409223227.rvf6tfhvgnpzmabn@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Content-Disposition: inline
In-Reply-To: <20210409223227.rvf6tfhvgnpzmabn@treble>
X-Cookie: Air is water with holes in it.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 09, 2021 at 05:32:27PM -0500, Josh Poimboeuf wrote:

> Hm, for that matter, even without renaming things, a comment above
> stack_trace_save_tsk_reliable() describing the meaning of "reliable"
> would be a good idea.

Might be better to place something at the prototype for
arch_stack_walk_reliable() or cross link the two since that's where any
new architectures should be starting, or perhaps even better to extend
the document that Mark wrote further and point to that from both places. =
=20

Some more explict pointer to live patching as the only user would
definitely be good but I think the more important thing would be writing
down any assumptions in the API that aren't already written down and
we're supposed to be relying on.  Mark's document captured a lot of it
but it sounds like there's more here, and even with knowing that this
interface is only used by live patch and digging into what it does it's
not always clear what happens to work with the code right now and what's
something that's suitable to be relied on.

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB0fHQACgkQJNaLcl1U
h9BPRAf+NknqRddw9/JMSV4GN9JKMESH9K3fOY4CyjuolYmZJoCKKoCAmXcWCaun
V99Qs8EJGcRlgqV3nwc1EeEvRkb44OM905mGy1Dpu90+Xb/9lFJypW/Ob6EnucQh
1UqAN912l8kcF/hz2LPA/OIogUQxpoxxcvwy6UdfMigJlFAdCU3rZXX0OP3OKPIT
Yu5eV2u/lgIQCBqZFg+hsDw/gA66IMq8TGm8GKF7opJmerVc3cGUpTKHBZ2hdynq
3QTQTEasr1BQ+zxkHonAmnqduIBVfHRGLkfbdb/tdPnwPaHF6fcOe0KiXGJtZKDR
RtvU1zr4YAGT8A5XEy7QiYr0Xqu7uQ==
=EZ5K
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
