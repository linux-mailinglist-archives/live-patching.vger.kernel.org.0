Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EAB434E6D
	for <lists+live-patching@lfdr.de>; Wed, 20 Oct 2021 16:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhJTPBy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Oct 2021 11:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhJTPBy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Oct 2021 11:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8646D6135F;
        Wed, 20 Oct 2021 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634741980;
        bh=YrONzKcAhydCls+3APmmyxq1BG0aGp6PcLZnHTAcfDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EaG1j+7H/TUgyCZp3YkGj0cNrLC0dp5dAkO65rShX82aEdWUv2Ue/LGwv6zHvT3Kr
         0CLjqEs19CQw4w6f+1pOLmRMLPnSql8KOzKBYECaNp1tHlBgAKAME1ybd/OrHb7W5m
         p18pBHtIgwcWLZEB1Mc22M5T6TJRGI8CKr4SiA+Jgdj95leICAe2lNwUdBNT0aBjP/
         gSPWnjy5s0kf891tS1oevjuwodS0pF1FU6YsHscqDABCgmyeX9t4oxKCcVpPj9moxx
         PXwzJK/+x/a9KOrCnbIH/lrp89Nh6ZGSkBR/Y+0ktNbCPfKRwBy0TT51Ohbzo8R4sT
         amrtQaAZnH65A==
Date:   Wed, 20 Oct 2021 15:59:37 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 02/11] arm64: Make perf_callchain_kernel() use
 arch_stack_walk()
Message-ID: <YXAu2aXqBU3rO5e+@sirena.org.uk>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0OjbTQTv4ED8ZjVP"
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-3-madvenka@linux.microsoft.com>
X-Cookie: I program, therefore I am.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--0OjbTQTv4ED8ZjVP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 09:58:38PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Currently, perf_callchain_kernel() in ARM64 code walks the stack using
> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
> instead. This makes maintenance easier.

>  static bool callchain_trace(void *data, unsigned long pc)
>  {
>  	struct perf_callchain_entry_ctx *entry =3D data;
> -	perf_callchain_store(entry, pc);
> -	return true;
> +	return perf_callchain_store(entry, pc) =3D=3D 0;
>  }

This changes us from unconditionally doing the whole walk to returning
an error if perf_callchain_store() returns an error so it's not quite a
straight transform, though since that seems like a useful improvement
which most likely  on't have any practical impact that's fine.

Reviewed-by: Mark Brown <broonie@kernel.org>

--0OjbTQTv4ED8ZjVP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFwLtgACgkQJNaLcl1U
h9DGlQf9EnRXgRKnKwL2lcj9Tf5P/zGR2UVLC51sGcsAxbyAbr51NzQfPKLAEylw
FI+VRW0ibqzD2wpmn9kb7boz99gz99qrlLmBzP6OTEqODAT8CVGY9YeciG9BKHtq
2Jrai3sp33jq3ox0bNtWeJ1YH1BJXlvDG+dUs7V8tytRqzOc06lVLnpmsI29g4So
v5J8VVnx/UNF8jXguz16m2XPmH9C8rkgFVFAz5HxNa9gJBkCB3Gl0OeqE7cUBauz
AhBkwX+T+t3IGwazfFl1LkbP1h+ikfCZ6gGLvcqsl13ZsmsfWxu3fJi6sOZobGwC
VBSNqEWBYqpINLr+jp/J4mtG2929qQ==
=wuCL
-----END PGP SIGNATURE-----

--0OjbTQTv4ED8ZjVP--
