Return-Path: <live-patching+bounces-628-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC5197004F
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 08:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C676B1F23938
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 06:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7027312FB34;
	Sat,  7 Sep 2024 06:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gl6QjXw7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3872942A9D;
	Sat,  7 Sep 2024 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725690508; cv=none; b=acHxdyhRAAFvK+Qa+RZJnJvDqAmNVXFcqT4BD0hhA7e+2YgrVpCo2Zp5/omNbjwXTljg9EgOcpVGAjg8IDaKHT39wWsXWu5NaQ4qNZOOhSMXuvAxdBEeJErHjQS/Er58+r5m07+/6pbzJwrq/h9TydiCpv2lVkobGHNuBnxOPbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725690508; c=relaxed/simple;
	bh=uBZ0X8gJsXD8UDVVejaD2DgB5/Xf1aicgnvPid2ISLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ap5gEy2WEtICE5fCrOcBHTaJklv1M5L1sI/wS0L6ZI6uwHzVyHZjK3snVhzQ8YIft+U2zWLBXXeIX7Wrs/ZG8GiuD7s/y/4c8syTcHkLlR6aziq7YqKdiqkMB4DUStbnj5bMVbJD+jUrOtmh2p3DEE+JF9wbXS/U7IOvS7FM6/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gl6QjXw7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9DDC4CEC2;
	Sat,  7 Sep 2024 06:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725690507;
	bh=uBZ0X8gJsXD8UDVVejaD2DgB5/Xf1aicgnvPid2ISLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gl6QjXw7Rxyq0dKBCPTdypppJeWtQ+rJy7tLNmVDLiszMkCAs35p5MZKqkb5ZzIXk
	 QUADeYWIVdgeEkAwBOCX2mcL0OvWpm4HZXiKNU18udV9RBAMKw6qXlxW28Df7QMSHe
	 OQWTvHbYuThOvJxOY/qTcatSrxswoCMKkexyf4EI+k8u4SLLURzc5ttQuVxjs0l4jh
	 DeE4zTLdW0wNV6cTVog1P7k/9RzKo1bpz+gNuksfP8Z9vO4bjygOyOyZK8iOxCur28
	 IvR+fp7HDg0rpsRTgbPwXLeK6pFrK5Op1gJqANHMo06sLF4VCtGmazyf5y+5tEGLII
	 Q4B5pwoWtSjmw==
Date: Fri, 6 Sep 2024 23:28:25 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Weinan Liu <wnliu@google.com>
Cc: jikos@kernel.org, joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, mbenes@suse.cz, mpdesouza@suse.com,
	peterz@infradead.org, pmladek@suse.com, song@kernel.org,
	x86@kernel.org
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entrie
Message-ID: <20240907062825.q2v5dfaeexmqgytv@treble>
References: <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240906065132.35917-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240906065132.35917-1-wnliu@google.com>

On Fri, Sep 06, 2024 at 06:51:32AM +0000, Weinan Liu wrote:
> I'm observing multiple compilation errors when using clang-16 after applying this particular patch.
> 
> # CC      init/main.o
> <instantiation>:4:1: error: symbol '__bug_table_0' is already defined
> __bug_table_0:

Thanks for the report.  So far my tests have only been with gcc but I
will try clang soon.

-- 
Josh

