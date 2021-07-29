Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070803DA6E1
	for <lists+live-patching@lfdr.de>; Thu, 29 Jul 2021 16:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhG2Owh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Jul 2021 10:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237204AbhG2Owh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Jul 2021 10:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05093604DC;
        Thu, 29 Jul 2021 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627570354;
        bh=tlr6WfyAAfYIOdiTBqFltGkyg5uAuLp75iQ4ftRMncg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l4YivkEzcgjZAW7uNZ1Smg+4IvuOkmGFdXeC38ea30J5dD02s/HnACqaZsYos143X
         MMJSfbD95yJMFN2FYVsj99SJNghH0D8AVkz19WACcR9RQzaVw2duwWUpHYbm6kO6Dn
         k7uvd0vus2Dx95TJ6j4IZEbjvczQRoGaktY6KEakkEXPiVqC3EkbZoSNAJqpEk9NPQ
         O2ipJqRrpX6D/mlOFSLXsbbJW31CQv/0r4Au5ciTdRaxvQpAQdQNC/nidEXQIz81ST
         1FDgJ8x+qHXXJ5dKUq2eafsc7ahNDY/HWHq0Xz6VBGaEsru9k8Lfj37UsYL4eoIlYD
         84VIu9p8BT7ig==
Date:   Thu, 29 Jul 2021 15:52:10 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v6 3/3] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <20210729145210.GP4670@sirena.org.uk>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
 <20210630223356.58714-4-madvenka@linux.microsoft.com>
 <20210728172523.GB47345@C02TD0UTHF1T.local>
 <f9931a57-7a81-867b-fa2a-499d441c5acd@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="K9FEQnHYtEQyKlzu"
Content-Disposition: inline
In-Reply-To: <f9931a57-7a81-867b-fa2a-499d441c5acd@linux.microsoft.com>
X-Cookie: Vini, vidi, Linux!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--K9FEQnHYtEQyKlzu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 29, 2021 at 09:06:26AM -0500, Madhavan T. Venkataraman wrote:
> On 7/28/21 12:25 PM, Mark Rutland wrote:
> > On Wed, Jun 30, 2021 at 05:33:56PM -0500, madvenka@linux.microsoft.com wrote:

> > Since some of the above is speculative (e.g. the bit about optprobes),
> > and as code will change over time, I think we should have a much terser
> > comment, e.g.

> > 	/*
> > 	 * As SYM_CODE functions don't follow the usual calling
> > 	 * conventions, we assume by default that any SYM_CODE function
> > 	 * cannot be unwound reliably.
> > 	 *
> > 	 * Note that this includes exception entry/return sequences and
> > 	 * trampoline for ftrace and kprobes.
> > 	 */

> Just to confirm, are you suggesting that I remove the entire large comment
> detailing the various cases and replace the whole thing with the terse comment?
> I did the large comment because of Mark Brown's input that we must be verbose
> about all the cases so that it is clear in the future what the different
> cases are and how we handle them in this code. As the code evolves, the comments
> would evolve.

I do agree with Mark that this has probably gone from one extreme to the
other and could be cut back a lot - originally it didn't reference there
being complicated cases like the trampoline at all IIRC so you needed
external knowledge to figure out that those cases were handled.

--K9FEQnHYtEQyKlzu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmECwJkACgkQJNaLcl1U
h9CC9wf8DqjxuFSwcUy/+ixIXHiCPRzxZpCl+PK99VCWgx6pnx+ndjI6ulrAnESa
D9dmwiLY6mPNFQYwHnyZF3n7+2QvlvJ0vtAfYzKTAD2GL5s8GU9eMCGkEeHCOdON
vB9sT5dccjFTmyLsAXhYbET2Yrrir4Hb9mgIWW4e5/cl/lliMmgvOCjrbvA4ZDSL
gMi++LRG+b5NJWoGBneeRug/uRq+wH3rVy7HESZWL4dkwemxoqIOrJuZ8pu1sHcO
UplFpWBgmQUahCKe6T8vb23V45XOClSTaowYCEJZprveu5vOE2y+IFcwVA9chXrD
XxdGLN9KS2gHj1Vw+RNnjG/IxwoH6Q==
=4mHi
-----END PGP SIGNATURE-----

--K9FEQnHYtEQyKlzu--
