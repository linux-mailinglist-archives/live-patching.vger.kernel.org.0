Return-Path: <live-patching+bounces-1722-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAEEB860E1
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 18:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 604B41893D69
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 16:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03ED30748A;
	Thu, 18 Sep 2025 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivzsD39Y"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882132857C7;
	Thu, 18 Sep 2025 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758213155; cv=none; b=iUMCLqRUb+FKxN/gNrkbgK93NZi0CnCT1XiOv6ybF2osJuPa88GpKNt7s1xeGWfBFN/Yq4sS0bsFePr2a+12yT0QV1BcsTwzatrkWKdxzyDDXSSWVy41fPVXGcIeBGLv7rn9Fqr0Ufo6OSINFTucBQO0wsxdrGHedsnZ9yLdhl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758213155; c=relaxed/simple;
	bh=jn+JH6LH9Wz2aiaW/mCQTihJ6exYp7EUuqN/5K7KMrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caGm4oDUwpEcdbZlpMMkFQNlwhfcCNk5jHSsA6t4Lxm3uza0hasIfC6BvbX4xLhVGlyopQizDiqWCPAyO5wdQkEr33mFxkmMThx1WwsBFf5kHDHDkS/+tp+u27yiljZ4fLBo4eIVrj2E8U6yPvqx1O8X1yxOuTfUFS6RNIKP26M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivzsD39Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3821EC4CEE7;
	Thu, 18 Sep 2025 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758213155;
	bh=jn+JH6LH9Wz2aiaW/mCQTihJ6exYp7EUuqN/5K7KMrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ivzsD39YXUGuXu9OGIwyNud7igh2en/gZCnt5jljXIPm9fgrFx50uUCDBaTxA6/bR
	 gWennGN/qdUxGmIFou1LW9mjN4voJX4ypphbRhgcNF/0AodYjGTqHYvxJwV84n0CUi
	 wXhIyMQ+Vj/FrBuPh7l4mGsu4C8Kp5cDFKB6JQ5hjx7qCbkZu6DBeZiqdRGk9pHgnb
	 liwx7lt9YdZDvRyp0bT47zW6WfTvms8JkmEjXPiFladTgCOxSrm7PmYS3JHt+2Nfy5
	 Ma9gxvI7661Ar7JaheuhK3RjVaCGkDdS7OMCMi1RsO9s3c+dJHKP9ya3SICwwqsLWB
	 UfyB36N4OZavw==
Date: Thu, 18 Sep 2025 09:32:32 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Dylan Hatch <dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 00/63] objtool,livepatch: klp-build livepatch module
 generation
Message-ID: <qlstefzbrincl33pr73wnuas2hq6o5pj5kllnkzc2vz7xpuk6f@4ulqc57yo4t6>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>

On Wed, Sep 17, 2025 at 09:03:08AM -0700, Josh Poimboeuf wrote:
> Changes since v3 (https://lore.kernel.org/cover.1750980516.git.jpoimboe@kernel.org):
> 
> - Get rid of the SHF_MERGE+SHF_WRITE toolchain shenanigans in favor of
>   simple .discard.annotate_data annotations
> - Fix potential double free in elf_create_reloc()
> - Sync interval_tree_generic.h (Peter)
> - Refactor prefix symbol creation error handling
> - Rebase on tip/master and fix new issue (--checksum getting added with --noabs)
> 
> (v3..v4 diff below)

git branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v4

-- 
Josh

