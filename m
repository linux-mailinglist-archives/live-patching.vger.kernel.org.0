Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C676F340877
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhCRPJV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 11:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231630AbhCRPJK (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 11:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C31A264F18;
        Thu, 18 Mar 2021 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616080150;
        bh=ihSRn3eCfFRKxgm1QbcvjC81+/Qc2nVvOJSuaOSKdzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=On20tsjacXNBd5cSVVepr7e3k22nihSQwWvj0XFL0/G6GyTW/2v+GCpk0P9khoPjU
         b2KdNI0iCWXk4iOpMYSEP7xoulMa3tXorqyiCqgXvGtkYsv7Yw83rFPGg/K/YktGu/
         PDlZ+g6WF3J5twEbo7EcMStTwe4T0NIiQIiKF3/457PEQcbY7rEZgs5NuTbKP4oSYi
         Lq49KZZsQxT8Xi6WRKNQ0nGcDqiz7JhJncLVFdheWJTff+ag87abz23+UHkgwYe1Or
         8MEkRluGobnYvOnOq9nnF1zSwcNkQwkA8kcrGFTlSJs9TmQT4RT8FgCbJMUn4zgykX
         9p6U9JazuoiKQ==
Date:   Thu, 18 Mar 2021 15:09:05 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] arm64: Implement stack trace termination
 record
Message-ID: <20210318150905.GL5469@sirena.org.uk>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Rzq/nSLlHy1djmXS"
Content-Disposition: inline
In-Reply-To: <20210315165800.5948-2-madvenka@linux.microsoft.com>
X-Cookie: You are false data.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--Rzq/nSLlHy1djmXS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 15, 2021 at 11:57:53AM -0500, madvenka@linux.microsoft.com wrote:

> In summary, task pt_regs->stackframe is where a successful stack trace ends.

>         .if \el == 0
> -       mov     x29, xzr
> +       stp     xzr, xzr, [sp, #S_STACKFRAME]
>         .else
>         stp     x29, x22, [sp, #S_STACKFRAME]
> -       add     x29, sp, #S_STACKFRAME
>         .endif
> +       add     x29, sp, #S_STACKFRAME

For both user and kernel threads this patch (at least by itself) results
in an additional record being reported in stack traces with a NULL
function pointer since it keeps the existing record where it is and adds
this new fixed record below it.  This is addressed for the kernel later
in the series, by "arm64: Terminate the stack trace at TASK_FRAME and
EL0_FRAME", but will still be visible to other unwinders such as
debuggers.  I'm not sure that this *matters* but it might and should at
least be called out more explicitly.

If we are going to add the extra record there would probably be less
potential for confusion if we pointed it at some sensibly named dummy
function so anything or anyone that does see it on the stack doesn't get
confused by a NULL.

--Rzq/nSLlHy1djmXS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBTbRAACgkQJNaLcl1U
h9DmMQf+M9PK8FtY3Ic0yjw1SVNJTlwP54wmrt6iAnWsMzbEPx7OLaDaGtaFuS6s
78vBrZXVuRUMQdgcMLXWtbWlDlZyroQRE0T5yrkUdlSNFAgqxLCA+kSLH1LcHvmT
9TsWtLmbAAhpJZMZ0mcLRA+m+WZObJuhK43QYNdNRDi//kQi5VTaRooVLaOQTV/m
gF15oC40H6z5lxuVXFhHFrJ6TfAl4sNRMTOb4qpjcGlI2+rnqgsNivEGV50b/uM2
RhPlJ8aWddJkOvFKEsP39ZCNUUMJucLpPupkywrZC0yA+cCfYG3QkTm/kEFoPJoj
BSa3OlK7eFLdTDKWXv/5SJyjdK5fUQ==
=Gn+A
-----END PGP SIGNATURE-----

--Rzq/nSLlHy1djmXS--
