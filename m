Return-Path: <live-patching+bounces-484-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DED7494FCA6
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 06:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1D401C223AF
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 04:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E501CD23;
	Tue, 13 Aug 2024 04:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9icMtwW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559831C68C;
	Tue, 13 Aug 2024 04:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723523354; cv=none; b=o1iVr+JOfsocOCCkXSnsvP1WWMtozt7CcSq+m829J4JcE6FQHJFsqj6US1UPqoMV0yv+LTH5Mo1/OjEWMzRqurJj6BOx4R9F1R7o/bJdBsariFbPl36hD/PeBP7GZnGBIu+jz0/JVJIssEsoorrnNy6ZIAhL6xCRzZsSzdrQPWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723523354; c=relaxed/simple;
	bh=5yRDZMRHZuD+/2KSqyv63RNLA87tSz/Y9Y0k+5NAKIc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=csRV//sW1ZrpWpaKnoNVfTyQhprwA3H36dVlw1mIjd+xBNo+lFrRUUz0JMKj2ovcSQiwlJwNng6boxbKLE0fFrPo4FTtwT+Eww/rBy6h49VXndc9NKBaBUduekiHW+gOPWEuKYuPt3tHkW8eootbQBckMwCbNCD8K5/LUFLhWn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9icMtwW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0E5C4AF11;
	Tue, 13 Aug 2024 04:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723523353;
	bh=5yRDZMRHZuD+/2KSqyv63RNLA87tSz/Y9Y0k+5NAKIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G9icMtwWdCjSXMe+1oYPqKm22QG6tmcl+25xu7j10bOW4VbnWBN9QAwkYLxElOVID
	 +yGkC/lp8YJmwNGjAjNO7vDx15eQPFy9S8BzQxezpA6qd+sm92Ugyt6V355cawysgm
	 Fuzmu0aaMwnzAnEjtKUILM4RlT/oZM4Y4Yb3JyKoiK8q1RYCRKXsZoIPU0MAj+dGGQ
	 IvtzxKXqJ/AdXlVNM2XF2S6uHyax1SD+xG11qgm1IbNrsMvcZjvT7cx5lGhWfE5U6J
	 yoUh6m+JmADrNBKZDTKz1CPYPEHpd17q8kEYK4iOqPTMk4bftayAjx1VuRjVq1/iqq
	 VzJFJf/FI4kfQ==
Date: Tue, 13 Aug 2024 13:29:07 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 nathan@kernel.org, morbo@google.com, justinstitt@google.com,
 mcgrof@kernel.org, thunder.leizhen@huawei.com, kees@kernel.org,
 kernel-team@meta.com, mmaurer@google.com, samitolvanen@google.com,
 mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Message-Id: <20240813132907.e6f392ec38bcc08e6796a014@kernel.org>
In-Reply-To: <20240807220513.3100483-1-song@kernel.org>
References: <20240807220513.3100483-1-song@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Aug 2024 15:05:11 -0700
Song Liu <song@kernel.org> wrote:

> With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
> local symbols to avoid duplications. Existing scripts/kallsyms sorts
> symbols without .llvm.<hash> suffix. However, this causes quite some
> issues later on. Some users of kallsyms, such as livepatch, have to match
> symbols exactly.
> 
> Address this by sorting full symbols at build time, and let kallsyms
> lookup APIs to match the symbols exactly.
> 

I've tested this series and confirmed it makes kprobes work with llvm suffixed
symbols.

/sys/kernel/tracing # echo "p c_start.llvm.8011538628216713357" >> kprobe_events
 /sys/kernel/tracing # cat kprobe_events 
p:kprobes/p_c_start_llvm_8011538628216713357_0 c_start.llvm.8011538628216713357
/sys/kernel/tracing # echo "p c_start" >> kprobe_events 
/sys/kernel/tracing # cat kprobe_events 
p:kprobes/p_c_start_llvm_8011538628216713357_0 c_start.llvm.8011538628216713357
p:kprobes/p_c_start_0 c_start

And ftrace too.

/sys/kernel/tracing # grep ^c_start available_filter_functions
c_start.llvm.8011538628216713357
c_start
c_start.llvm.17132674095431275852

Tested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

for this series.

> Changes v2 => v3:
> 1. Remove the _without_suffix APIs, as kprobe will not use them.
>    (Masami Hiramatsu)
> 
> v2: https://lore.kernel.org/live-patching/20240802210836.2210140-1-song@kernel.org/T/#u
> 
> Changes v1 => v2:
> 1. Update the APIs to remove all .XXX suffixes (v1 only removes .llvm.*).
> 2. Rename the APIs as *_without_suffix. (Masami Hiramatsu)
> 3. Fix another user from kprobe. (Masami Hiramatsu)
> 4. Add tests for the new APIs in kallsyms_selftests.
> 
> v1: https://lore.kernel.org/live-patching/20240730005433.3559731-1-song@kernel.org/T/#u
> 
> Song Liu (2):
>   kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
>   kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
> 
>  kernel/kallsyms.c          | 55 +++++---------------------------------
>  kernel/kallsyms_selftest.c | 22 +--------------
>  scripts/kallsyms.c         | 31 ++-------------------
>  scripts/link-vmlinux.sh    |  4 ---
>  4 files changed, 9 insertions(+), 103 deletions(-)
> 
> --
> 2.43.5


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

