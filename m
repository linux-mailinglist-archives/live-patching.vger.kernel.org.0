Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845C9372D48
	for <lists+live-patching@lfdr.de>; Tue,  4 May 2021 17:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhEDPw2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 11:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhEDPw1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 11:52:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754DC60241;
        Tue,  4 May 2021 15:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620143492;
        bh=aukY94x5Rgz0iCTvcCLt9B4f7kXhPjoCjGzh7WJdghw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JE2OAUkhXOovXZtN4sAm+cPBFOv1RsnF8+qVnMm4eNA8VunFltvMm6dSKuOAEz+ez
         ZZ4PuKss9vfUkEaMIziWTo47roem0AxFoPKehijBm8GxV4Jnn2eZOaYFMsc8XiefxR
         jv90RVpkYK2jL6p2tE441LiAw4rSpAG87KhmUbmZo2HkILlNmBTL0igKIE7uNtVLN8
         jTg4/OY73P2FPRnhDmC+u4RrhTuVCbe90U80KUZe5gncs7YyG6mX4kvD7aM2Ohx+fU
         CoNGwokhmi6ANpzoRRLkVDQj7RhqhM5aQHjapPyZM4SvPTUXgovEf7R6QgolhITgXX
         lJU8xBvLbxZQQ==
Date:   Tue, 4 May 2021 16:50:56 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210504155056.GB7094@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20210503173615.21576-2-madvenka@linux.microsoft.com>
X-Cookie: MY income is ALL disposable!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 03, 2021 at 12:36:12PM -0500, madvenka@linux.microsoft.com wrote:

> +	/*
> +	 * First, make sure that the return address is a proper kernel text
> +	 * address. A NULL or invalid return address probably means there's
> +	 * some generated code which __kernel_text_address() doesn't know
> +	 * about. Mark the stack trace as not reliable.
> +	 */
> +	if (!__kernel_text_address(frame->pc)) {
> +		frame->reliable = false;
> +		return 0;
> +	}

Do we want the return here?  It means that...

> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	if (tsk->ret_stack &&
> -		(ptrauth_strip_insn_pac(frame->pc) == (unsigned long)return_to_handler)) {
> +		frame->pc == (unsigned long)return_to_handler) {
>  		struct ftrace_ret_stack *ret_stack;
>  		/*
>  		 * This is a case where function graph tracer has
> @@ -103,11 +117,10 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  		if (WARN_ON_ONCE(!ret_stack))
>  			return -EINVAL;
>  		frame->pc = ret_stack->ret;
> +		frame->pc = ptrauth_strip_insn_pac(frame->pc);
>  	}

...we skip this handling in the case where we're not in kernel code.  I
don't know off hand if that's a case that can happen right now but it
seems more robust to run through this and anything else we add later,
even if it's not relevant now changes either in the unwinder itself or
resulting from some future work elsewhere may mean it later becomes
important.  Skipping futher reliability checks is obviously fine if
we've already decided things aren't reliable but this is more than just
a reliability check.

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCRbV8ACgkQJNaLcl1U
h9DdXgf/btSEJgzLNnEf1rt/RIYhN5+o/eGdvZZ6fKKC2TbncPHuJBcr1vXjf4Dk
ygF68CwbtZ/VL7SdEBUCPc+fhy9wA8ezBxFAMGRdRktr7ppAxzPCfrqlr2wSTLIT
TvYv2lZO/jiY5DXqkDqvg8RscX6LMsw6AlNT0Z6eQQ090+pf2Fd9LG0tPwDnNAb0
0QJEvYSAJmG1PxANCeH9qcZ8tRuTiJH4pvG6sHs49ssiUIJcU1jtp0RyanuEzlEW
2dJqpPRDkLcPekGBv2eMH3fpd0ygmXrtsiirShtPooS0c2vTxpLc/XYWaMgID3v6
N7S+2iAcKA588sUxQh83GbO1W4Ai5Q==
=2xNV
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
