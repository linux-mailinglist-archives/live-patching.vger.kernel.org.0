Return-Path: <live-patching+bounces-1779-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EE487BF399D
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 23:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9399C4FDC13
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 21:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB472E7185;
	Mon, 20 Oct 2025 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6/8ohV9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6143A2D948F;
	Mon, 20 Oct 2025 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760993766; cv=none; b=sYCTKaaBvPMSY84tnG7QQ2dFHOECyR18ltQMXUVcGugrI9Yokyc8Wd357FJjyfC/dwpxHfVURd3L24AVsM5VPqswujrPZ4eNPYc5t5OaFMFPvIk4Pc7eonuucdfVAqmgy/xsABp/azdszJhYxPeu7W1YDMtRKLohkPJ9Goli+cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760993766; c=relaxed/simple;
	bh=66hdj7b7y+Bj5zeRUpxAhwQGqM4izk/68LS7m+Qzg/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNt2CTFZ75JnxpTFzt+FlBi9rNWkQq3m0vi6IqLNrp3DQB0rNCue3mRiGxzvsXQ0sjo8TAtmAzcRB/MVEx7uLhzAlTyKPchJQJlD1UQ32OVgABuf9ewLwthLZIOnLQTkvUvn2M8zlj0PhxZCeDlAIwh3FSU+OIlGIYRxCHH1Jn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6/8ohV9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6B9C113D0;
	Mon, 20 Oct 2025 20:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760993763;
	bh=66hdj7b7y+Bj5zeRUpxAhwQGqM4izk/68LS7m+Qzg/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F6/8ohV9ZYnO8vRdNbBAxCMoc9Z1NicjOla+oJI5DtEYRMPQgabph2uYomHoFeKpV
	 13sePFgOsMBXD+hkpE06kC23kSyw2uxyh8W0WAnaQo4rNvYV8J+urKdTW0uF5M22jd
	 CQ0fPlSR/18VkQqLw3va/zUygaL5N/E11AYtuCaa1BC06DJJkonc28aXHVI7zhTX2I
	 Dupa5BXClZz1Q/rNrXNB88GarRwS7ofqQiRJERvpvutJDzo+e3VKgze1V9PIjPIocD
	 Rhh6QsL5ne8NzSN0I0gfdo39nlB/cP4esoQjAlI1et6Miq550ppy1nSeZn83NbspDn
	 /dw3l/JNzgJug==
Date: Mon, 20 Oct 2025 21:55:57 +0100
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
Message-ID: <b97dd440-f41f-4c29-995b-a7dbafc0a7c7@sirena.org.uk>
References: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gT0UeSfDxwmsK2C3"
Content-Disposition: inline
In-Reply-To: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
X-Cookie: I doubt, therefore I might be.


--gT0UeSfDxwmsK2C3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 10:53:40AM -0700, Josh Poimboeuf wrote:
> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().
>=20
> It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
> MODULE_DEVICE_TABLE() to generate a symbol name which no longer matched
> the format expected by handle_moddevtable() in scripts/mod/file2alias.c.

I've not done an exhaustive test of all the impacted platforms but this
looks like it fixes things:

Tested-by: Mark Brown <broonie@kernel.org>

--gT0UeSfDxwmsK2C3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj2odwACgkQJNaLcl1U
h9BV/ggAgng2HBwL1s5B1qViSagc0m2td95awDa1wyhlBiAyiMY02BUy4MKFz2Wk
hAYWIMrMZLt/ygLXJXaNGbeJq/R3VS2gS5Cw2u4kgDNK6pfIpuj5GdXPo8MJXzOj
/blO628oMnCqGjNfJFSgrRtI6T55XLAKskUXi74FuWmV0+QQQPs73YxcFaEmt1/d
QBHmGF7anYNIcoyHOxcEernnetLsOKYswqRPWkfvkd1z7QD9ccVS8GxuvO188cNH
QQELtTE8mgbrBw/ypb8ZuB+Ei8RKFNrwujagZ6r+Y6nK+0a8WPROodp1E6CFI1lL
vft/FR3fRvJmS7YMuC1xL4/IdpdvWw==
=2pcA
-----END PGP SIGNATURE-----

--gT0UeSfDxwmsK2C3--

