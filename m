Return-Path: <live-patching+bounces-1789-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 39654BFBC13
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 14:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D971F35319E
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 12:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA4733FE1F;
	Wed, 22 Oct 2025 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHrfUKjI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0698B33F8C1;
	Wed, 22 Oct 2025 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761134508; cv=none; b=TbzqGSR4rCzs03w+sHe4odTSKZ/eCF9sdF37gotf9IJ8poa7rvdXHCUkYjpUAZXHwMFZwGMV6BE0FZMX3fbSSHa1aDS+8g8H8WaK7dIYcU+OZeZrQJdAG/AB4jweUNQRWRfRVvCtcrjLrDyoq3pu/jL7zTKguLL+/PC20cu/tvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761134508; c=relaxed/simple;
	bh=T556VrX6OouRZb5uhFtV/UG3SP+6hGynUByoORxI3mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeTNdO5jWtT0s6kOzOPqe8n0lx7sAdtcBrbiCZ7uqQHyLRAC+Aa08bAELfdZeam1lweqRx6Ru9zIeYC/SYMzIEcDTBsgAIvG+N4/1/vLIrylTyGqGLwY5T1KJPf/EzqV2WLHtIUBOpPYvTcilJgRLM0AXTSBPLESNm5S30fIV3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHrfUKjI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AC2C4CEE7;
	Wed, 22 Oct 2025 12:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761134506;
	bh=T556VrX6OouRZb5uhFtV/UG3SP+6hGynUByoORxI3mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FHrfUKjIvRuG7YNyifyHa7++HR1RY2e3Y2WXUjCvpotbZspUTcRm4/r6XLa4PUYUA
	 hud9W25pFBZ7muSSCsD8uzkxhEYuavxPJlJOYjnAhMgH+lYIuUQoQpPTTJ4DQ93WUu
	 Sn/FFV+uaOS4tuusG3sFflTcGaaTw/CnEqaHiYkgqsP/EVFNM5AhndhSu3oEiUAbeL
	 SuLg6bf/h1sUKq+LikS1a+BuydDwX+cahqHx7/9n7MgpAI700cU99867sln3z6DE/X
	 3mab2Fnc1+7XZHEdtr39jptKcfpUzWCUuaDkASZhd5jXgj0b2wHH/pH17I/xNhXFD8
	 D6Ahx7/gD/1OA==
Date: Wed, 22 Oct 2025 13:01:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Cosmin Tanislav <demonsingur@gmail.com>
Subject: Re: [PATCH] module: Fix device table module aliases
Message-ID: <13384578-a7e7-439a-8f30-387a2cb92680@sirena.org.uk>
References: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JFx3/RNbBAIdVwTo"
Content-Disposition: inline
In-Reply-To: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
X-Cookie: The early worm gets the late bird.


--JFx3/RNbBAIdVwTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 20, 2025 at 10:53:40AM -0700, Josh Poimboeuf wrote:

> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().

It'd be really good to get this fix applied, modules not loading is
hugely impacting CI coverage for -next - a lot of systems aren't even
able to get their rootfs due to the drivers for it being built as
modules.

--JFx3/RNbBAIdVwTo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj4x6MACgkQJNaLcl1U
h9A3+Af9EFeKJB8wqz9ZYQdGMRKwXP3WlXm9j/Kn8w47cMkgp4f4JJl2jwNbcBGs
eOQbK2gZna3J4bESlDor/iADo29LigZnyU3orjfqIcSoZZOjgMnGvbmUTkkuAR51
LB7c30kTeRCjqH+8IPivWxf2PEEGOh8rpdMgxukOcEpRBZN6Q0fnkn3kmIVdJ34a
IfYQo2Hr36BETa4d+BAWSqF3TNunPZLQM0SZVpTGkMkKKLBesGg/9SppYmASOCcP
5hP7x9Dq8Lm2vXCQ/cqEc5jG4I0cvZmG41iKA2jaMH0MHjGtve/6GAesYfdaCRs7
7WsRcQnVxMHQ1T3+4eklvGL/c3SJDA==
=40Xa
-----END PGP SIGNATURE-----

--JFx3/RNbBAIdVwTo--

