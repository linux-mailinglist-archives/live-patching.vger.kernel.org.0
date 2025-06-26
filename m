Return-Path: <live-patching+bounces-1528-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC552AEAA70
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBFB31C27191
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF2021773F;
	Thu, 26 Jun 2025 23:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdI1jRH7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DDD1DED7B;
	Thu, 26 Jun 2025 23:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750979944; cv=none; b=oWhV5ylG0A2MCVJKNHB8lqOafRsj42c0cZpMLZnJVRlNN8WqCuJvW/hrObzXsqRnLT8N4C39UThlc1Hz/97B4hw3cZpFrA2PXBi4Af5t2Fwy0itPNYqan3gDqoct6liqE+mcyXA3R6kRWi7V4NDjTJKBh/7iPVxxN3V1oy6jo3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750979944; c=relaxed/simple;
	bh=odKyuWmStJeBz0KIxuVQisMijD8o7K/ItudxpDnqQ2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTlQSBVVf/khkiTbxBwqmMoFPaXTSmrwOccl8FVW0niW1nl9t9EdNJZvh/YxKF4eHOFMcXoJx8Z7T8ELooIgTEjDlEFeHGOQY6ajD5z+MF1hdiwXd2tzZQY0VSjvLWasUry0nB/Yh3km8vZnqTuiyIw6rKXnECyiWBALAkbBv8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdI1jRH7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6D8C4CEEB;
	Thu, 26 Jun 2025 23:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750979943;
	bh=odKyuWmStJeBz0KIxuVQisMijD8o7K/ItudxpDnqQ2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UdI1jRH7F6IcCFJqJ6YcL7UFo5dWP5a8sqnJVhzBp6L5UX8CCs+riGlgzJaAeG37C
	 HoB3BZHqIYQOijfPxm8kvbxTkixvTsoAjqGvLJycJKJVQmFx0BHLnyVlD075Y9JjJD
	 aYklZ7wYiiJDtZqEZ33c9D3ANT+IvR+U9wF4GRXesm4EXGH98g9CVPi2yoST5TbnEa
	 KCrqp6VBbcFyFrppsIG24ylVOaUGnexEgr+/964YUHSqqt1QJ/epLByT9jK2iwbNi0
	 SdjitY2NNqW6EEL0efAPYXZHqIx3MFnEoF1Hwjxf2AhfZsXh1sL7JEsm1hug4y+drg
	 WvbdWoFGZyAWw==
Date: Thu, 26 Jun 2025 16:19:00 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 54/62] objtool/klp: Add post-link subcommand to
 finalize livepatch modules
Message-ID: <ffhirghzkgoah3fjh6mk4kwi5ygeb5ajt52uop3lvl5ruftojk@eccsgjesmqiw>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <bcd83c55cdaba69f149f22e6215b202b0c713946.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bcd83c55cdaba69f149f22e6215b202b0c713946.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:17:18PM -0700, Josh Poimboeuf wrote:
> Livepatch needs some ELF magic which linkers don't like:
> 
>   - Two relocation sections (.rela*, .klp.rela*) for the same text
>     section.
> 
>   - Use of SHN_LIVEPATCH to mark livepatch symbols.
> 
> Unfortunately linkers tend to mangle such things.  To work around that,
> klp diff generates a linker-compliant intermediate binary which encodes
> the relevant KLP section/reloc/symbol metadata.
> 
> After module linking, the .ko then needs to be converted to an actual
> livepatch module.  Introduce a new klp post-link subcommand to do so.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

FWIW, I have plans to get rid of this post-link step by saying goodbye
to "klp relocs" altogether.

I have a working PoC which implements livepatch "submodules" which are
specific to their target object (vmlinux or module).  The top-level
livepatch module keeps its submodule .ko binaries in memory (embedded in
its private data) and loads/unloads them on demand.

The end result looks a lot cleaner.  It also removes the restrictions we
have today which don't allow references to static call/branch keys which
live in modules.

That will have to be another patch set though, 63 patches is plenty long
enough already.

-- 
Josh

