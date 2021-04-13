Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C28D35DD4A
	for <lists+live-patching@lfdr.de>; Tue, 13 Apr 2021 13:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345106AbhDMLDh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Apr 2021 07:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345098AbhDMLDg (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Apr 2021 07:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 947F3613C1;
        Tue, 13 Apr 2021 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618311797;
        bh=YN5QtVOU/fCpbRgeqeMvCPohzoOdRoQ9xxZfw5H3Yww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OvaM3/wIW2ManMdV4piZJcIhWIWR1AX9Pwrl00bRt/FBdLpPjuoT/a9bU1OsxdxkQ
         tbr95XbtmLktuTssfIl9IxPn+mgm+l89cZCCuhyqawa4c1tkqEYHhCjLI84g+fwl6g
         4HfVwdCi8SHULz+aVMvuQ/xNMydNz+GRsTP3dCbx9tFpcsc5zbCBby4xH9KfRlOkAI
         EJk0aR9ZICE1yIqna6zeiID854O+u6QZ/iAxvDepDox6pownKCwYD+gpfjpZ3DOszd
         e7i4Ya8OCwh747wqlL+sYbRv65vRfoKrOj20+y1MgYkOM976HILd5JNgCpKVJ8B9iG
         +EMwocASPfApQ==
Date:   Tue, 13 Apr 2021 12:02:55 +0100
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
Message-ID: <20210413110255.GB5586@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <20210412173617.GE5379@sirena.org.uk>
 <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
X-Cookie: Shake well before using.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2021 at 02:55:35PM -0500, Madhavan T. Venkataraman wrote:

>=20
> OK. Just so I am clear on the whole picture, let me state my understandin=
g so far.
> Correct me if I am wrong.

> 1. We are hoping that we can convert a significant number of SYM_CODE fun=
ctions to
>    SYM_FUNC functions by providing them with a proper FP prolog and epilo=
g so that
>    we can get objtool coverage for them. These don't need any blacklistin=
g.

I wouldn't expect to be converting lots of SYM_CODE to SYM_FUNC.  I'd
expect the overwhelming majority of SYM_CODE to be SYM_CODE because it's
required to be non standard due to some external interface - things like
the exception vectors, ftrace, and stuff around suspend/hibernate.  A
quick grep seems to confirm this.

> 3. We are going to assume that the reliable unwinder is only for livepatc=
h purposes
>    and will only be invoked on a task that is not currently running. The =
task either

The reliable unwinder can also be invoked on itself.

> 4. So, the only functions that will need blacklisting are the remaining S=
YM_CODE functions
>    that might give up the CPU voluntarily. At this point, I am not even s=
ure how
>    many of these will exist. One hopes that all of these would have ended=
 up as
>    SYM_FUNC functions in (1).

There's stuff like ret_from_fork there.

> I suggest we do (3) first. Then, review the assembly functions to do (1).=
 Then, review the
> remaining ones to see which ones must be blacklisted, if any.

I'm not clear what the concrete steps you're planning to do first are
there - your 3 seems like a statement of assumptions.  For flagging
functions I do think it'd be safer to default to assuming that all
SYM_CODE functions can't be unwound reliably rather than only explicitly
listing ones that cause problems.

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB1el4ACgkQJNaLcl1U
h9A3PQf/VI0TAe26+qZlWoT60AoRxJ3FU1apGj5nPlp8H9phWjbQEmnD6j5LHfPL
1VAxKkqe73NAB2/t6LdOfanOjqzJ+YnPkZvV1j6yJLsMnwpDTwUJxykpIPH5nkcj
2Tx3mGR72FnQv2ubUdFeO2Wi4LA7js2uAPZvlZkBMgekd8TMpgIHxTIbJszXIAR2
AQP3x+0EmuigidoaSxvnAtTKnBK3z+/pc95xtlQgGpXX/WdrCVmkiCJQ0iaq8b17
St7awxqETDC7/7AixyeIwzx9P9iM7J9CfdiqREFfEeJ++Zy4z7XYK+0dJbpImCc9
cG1nWivPtAK2O/6Ld0oVIk5HRUGtFg==
=iS5y
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
