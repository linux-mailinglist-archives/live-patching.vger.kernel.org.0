Return-Path: <live-patching+bounces-480-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A17394F572
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2024 18:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C51128370A
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2024 16:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9991187870;
	Mon, 12 Aug 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kkFVSmwV"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F124317C;
	Mon, 12 Aug 2024 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723481861; cv=none; b=GF8JL6pWsqgPFjQBEhr7Q7xhe/XIJHr556LuqWDkLu+Bc+SQ26IpWfEQfHPOpIgJqX9ZaO4tKJ6EEdW61Jz+TyXT0rslfF5S/5Rku2+SaCodfzCmbe3RnI8YnO4tSd90T1hTS14ZFkGlZpmzw5IpjkxAiAYWfzXsZrs0EMU0Sdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723481861; c=relaxed/simple;
	bh=txzhRNbmX6zZAFmH+HTZX0oiIhxSTK3mHHI7oZiES8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6ZF/6HoM4L7acJolsaXdD0fKZ5XtWJLLrrbnfkBrHs8pFKK3orntwQbMewcKF5a2vPsDgEnVlX7eW31RVj1g+o+Cz9dxksrit/1KR5ltNa5+HHQBT/pW56cUo/2HvjFYvLJ2CNI5iw71ZoEeNEAY+R+FR3E0c8O/WPJqJDOH2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kkFVSmwV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tc/Gv4mvT00bJfk4/I8PkOr0Zzy+OONb/HA1C3fFiK8=; b=kkFVSmwVEffvXLoCi3EkDCQKnp
	MLVSW54uOnl2TS2wdx5G3eNMebO2SqmGZUI0rQMKLZ7BxyxTCLvQpTNO7lmJTvP8xA6tPhNiGjG2L
	ozEQmKezp2iqfe1f+tbT0RXoPPYqNS4Vw6vp1aAl9U17a6rsF0U2auYy5rfUjLRFJgdfWrPRql6tp
	zfjoH0AwP/BhjZYOwFMQueH9YH2lcRTAYKoSNaF/660fkOjo3ZO6mYokJmwMguFTz14fZjJ2NM+E9
	5ZL7sF+xFfQ+bzdKANChL4Pg/hyaf8xYwK68y85SlbiDI/UVdxHoZ3GQYhTuWYTwxdlRKa8e2CEUo
	BidHDa4A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdYMT-00000000xgw-332D;
	Mon, 12 Aug 2024 16:57:37 +0000
Date: Mon, 12 Aug 2024 09:57:37 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Song Liu <song@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>, "KE.LI" <like1@oppo.com>,
	Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Fangrui Song <maskray@google.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com,
	mmaurer@google.com, mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Message-ID: <Zro_AeCacGaLL3jq@bombadil.infradead.org>
References: <20240807220513.3100483-1-song@kernel.org>
 <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Aug 12, 2024 at 09:21:02AM -0700, Song Liu wrote:
> Hi folks,
> 
> Do we have more concerns and/or suggestions with this set? If not,
> what would be the next step for it?

I'm all for simplifying things, and this does just that, however,
I'm not the one you need to convince, the folks who added the original
hacks should provide their Reviewed-by / Tested-by not just for CONFIG_LTO_CLANG
but also given this provides an alternative fix, don't we want to invert
the order so we don't regress CONFIG_LTO_CLANG ? And shouldn't the patches
also have their respective Fixes tag?

Provided the commit logs are extended with Fixes and order is maintained
to be able to bisect correctly:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

