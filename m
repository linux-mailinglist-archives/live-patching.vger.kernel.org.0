Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ABC333EDB
	for <lists+live-patching@lfdr.de>; Wed, 10 Mar 2021 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhCJN1v (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Mar 2021 08:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhCJN11 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Mar 2021 08:27:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE5564FF7;
        Wed, 10 Mar 2021 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615382847;
        bh=FfYG4HSnZMF4JEobpIUzK9ujMCQ4hzxfRr0vd2iFSJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HwLZtuAROqKQC2VQP413P8AdCSOIWB3soto3vzlcgQMo5yS/TV5vxzMb3YsNZofm3
         1qG8aes0V4xk9WwpgTmrpkN+nGGwKF4XM4PL8Rpl4TkfrsCYgWdqAko1YN+dCb/+A0
         +NbKvi3+lAAfrUWoasTJeinguoD40yS5QFMgmqxkwgvH90Z/AxrPost6deBGsvNiwM
         FInkIZXNJmpFaVWA9aUT3AAYd7YSG5lSorlm3x89CUH3i36bAAxS8qkdut1UcjGrdw
         QawaMbHm41Q7MzyRWNX0z1ACT26UcvhTxLeeQ222z4prhA25GKE2tg8rfOENm9ep75
         uBH1WlCJ1hf+A==
Date:   Wed, 10 Mar 2021 13:26:15 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH] stacktrace: Move documentation for
 arch_stack_walk_reliable() to header
Message-ID: <20210310132615.GC4746@sirena.org.uk>
References: <20210309194125.652-1-broonie@kernel.org>
 <20210310052436.GA23521@zn.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <20210310052436.GA23521@zn.tnic>
X-Cookie: no maintenance:
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 10, 2021 at 06:24:36AM +0100, Borislav Petkov wrote:
> On Tue, Mar 09, 2021 at 07:41:25PM +0000, Mark Brown wrote:
> > Currently arch_stack_wallk_reliable() is documented with an identical

> LGTM.

> Holler if I should take this through tip.

Yes please, though there's a typo Peter pointed out in the commit log
above - should be walk not wallk.  Let me know if you want me to resend
for that.

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBIyPYACgkQJNaLcl1U
h9Bo1wf+PtmTrLqFBbY3HHo3Ufd2+iGwYOO71T6JYrqBdpCDaUGIvQj8U2fevLbj
z97fTwzwB1CJqVAtI+2sJuXNJw1UDEBOSIEmIoe/gXP75Pu9cx2/MHUCPV6kiNF1
kOf52dWsFCdj6WK1iHZUHZi2Xf4dBXQnJwbQ0myXMw9xqkYmoIVzwma0FeF591cF
fAKCrrW2URKm6TCCPSFeCDuDW5y6x7wI8Y+MX9cybPJgXnS0xHHFvr4cyXDQPPb4
3RLW4eb0yMM6CizFuz4dBEFQnwr+3u6Lnn9Tvjl9a/48YM71k/1KJ89aa3xMLb4o
ysZVUu0vS9i911IJxVP1kkITAfmtfA==
=QBwg
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
