Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3A7359D78
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 13:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhDILbe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 07:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233532AbhDILbc (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 07:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59CDA6113A;
        Fri,  9 Apr 2021 11:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617967879;
        bh=fUp0KpjNQFEeNM0zf+0A70wkSLLCHLMN8TUpFFkE/Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=trVdlCtfHEy41zGKMjob9ykuUD1Qjq3pGi4wPcrTsBrFrBpoFV4awRihVWa74ZlUO
         X8kaF5+9MazVIiXDLCW92DCjcVcZhoDXenOHyyH8bDyOy/4tZt+xBDGsJI36vTfVnp
         dtPmATsLtylovnLwq/Qhe4BxlcaKrL+UcXG7xFxmrb1U+FMYLHlqXxug7EcXWAiPN/
         CW3vRWtgmbSTOe2BfHgpeNOODK74yeOtJYAcLf2e7NFmxBNbK8a6Fg/rA0FkeitLoy
         veTNJZoy0kbq0iKhae8l+lS7xLcGeHBDFkpUAvmmKlydcStoSjq5o47c4jzqFElZPA
         X95ZXrN1eLITw==
Date:   Fri, 9 Apr 2021 12:31:01 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] arm64: Detect FTRACE cases that make the
 stack trace unreliable
Message-ID: <20210409113101.GA4499@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-4-madvenka@linux.microsoft.com>
 <20210408165825.GP4516@sirena.org.uk>
 <eacc6098-a15f-c07a-2730-cb16cb8e1982@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <eacc6098-a15f-c07a-2730-cb16cb8e1982@linux.microsoft.com>
X-Cookie: Ring around the collar.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 08, 2021 at 02:23:39PM -0500, Madhavan T. Venkataraman wrote:
> On 4/8/21 11:58 AM, Mark Brown wrote:

> > This looks good to me however I'd really like someone who has a firmer
> > understanding of what ftrace is doing to double check as it is entirely
> > likely that I am missing cases here, it seems likely that if I am
> > missing stuff it's extra stuff that needs to be added and we're not
> > actually making use of the reliability information yet.

> OK. So, do you have some specific reviewer(s) in mind? Apart from yourself, Mark Rutland and
> Josh Poimboeuf, these are some reviewers I can think of (in alphabetical order):

Mainly Mark Rutland, but generally someone else who has looked at ftrace
on arm64 in detail.  It was mainly a comment to say I wasn't going to do
any kind of Reviewed-by but also hadn't spotted any issues.

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBwOvQACgkQJNaLcl1U
h9C1ywf/Zbw1Z1QFQ9f8u2MHhFttf12fqFoSFd5iqQ9spEcbfaBlpTl2v8M/5H9h
R6oBURNPeVfVCxvv/71t9Orzqyn9ARMB/OizAb2stUPdlFcnKAYcK+EGhOLqLKvu
ROhmYPrJxYkjx9Qegny0xAZp5MrlJ6nmUDl8xOLJYYj706CxMFP5Ajsbx+iYk1ZE
s3sEJFrMhNTcQGo/Ov6u8icSdzC5GmdnbLZLZQABGM2XGtLYaI4OEAg9ZwXD/fIK
A97q5N6unW1DVvNGwOdKRGakFGw/B9JoLtSEvWjEpsDzePbgTOm5hiWQi1GZNR51
9te0IeS7HVke1UH7AXxDqXJPHrbPLg==
=neW0
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
