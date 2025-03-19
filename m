Return-Path: <live-patching+bounces-1300-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69352A6829F
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 02:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F03C618899C5
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 01:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA2D13A3ED;
	Wed, 19 Mar 2025 01:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyOaLxBh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA2C8615A;
	Wed, 19 Mar 2025 01:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742346198; cv=none; b=oKaSMrpt3kA7EmO5NWlcR2RygtjfMYNgndcQw4n3RjEAxNXU4RZtpeztvN+mGc7hIi1an70doInxpbjNxPGHHVGA95BoDZ5Ado9dO1cNk+hR/999AXRH8X6LQpnZBoKUSelk2G9rr6NUV/x+XzRl+8pgQ7d5ogTUA/GBf9EABKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742346198; c=relaxed/simple;
	bh=tPrURzCRqtqxEz8HWQbXFiAdcY7czjiPvG3bo9E4Fho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyZVlHwc99MlRZG11iW4O0e9ijdd+RisV/0kAqHh/TImjlWVrmDUFAVhUba9gt2917ylMuBZkfNRgzRFmSfw1WT6/O8Xs2dYB8Y2llc/DS/eY++Z1Ta2dnQnoo6MHw9dhG+FyYYAdPgz4dV6wurmH4uaWCfwCm8ri8qxi3bPr5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyOaLxBh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1882C4CEDD;
	Wed, 19 Mar 2025 01:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742346197;
	bh=tPrURzCRqtqxEz8HWQbXFiAdcY7czjiPvG3bo9E4Fho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZyOaLxBhfGDCCJtlIirn9aUPCbDBxyTUNaDhy3mFW0+3kXQiYQXXWtgJ60HSJoIUM
	 QjUI3Ufrvwho+S+Zj+AGeravryB6jHpN7hKDlru1VfuV7wcx2CbM2dzch0YdBh1Zd2
	 eEpeidvp4//kQJ6oZ/s58fTBgTGSWbL/TnHkY3lFEVZo3JxPm6PnAt9NqvqM8PEkr5
	 C9qwHUIAEjNNiWYTvvUQir+hYNVZ3qOVU/orXdioAkjYcUhSv9R1DrDtqifwmS0V5H
	 bB2AXb2ETODHdWnPjtocTOUoKdtbb+jqpQ3MVGgSRGLLhIxWEuz5A/Gpbmy5D07XdF
	 ZRIwX6gCUeEAA==
Date: Tue, 18 Mar 2025 18:03:13 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, indu.bhagat@oracle.com, 
	puranjay@kernel.org, wnliu@google.com, irogers@google.com, joe.lawrence@redhat.com, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <pym6gfbapfy6qlmduszjk6tf2oc2fv4rtxgwjgex7bwlgpfwvs@bkt7qfmf7rc4>
References: <20250308012742.3208215-1-song@kernel.org>
 <20250308012742.3208215-2-song@kernel.org>
 <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
 <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>
 <ox4c6flgu7mzkvyontbz2budummiu7e6icke7xl3msmuj2q2ii@xb5mvqcst2vg>
 <CAPhsuW4BEDU=ZJavnofZtygGcQ9AJ5F2jJiuV6-nsnbZD+Gg-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4BEDU=ZJavnofZtygGcQ9AJ5F2jJiuV6-nsnbZD+Gg-Q@mail.gmail.com>

On Tue, Mar 18, 2025 at 04:38:20PM -0700, Song Liu wrote:
> On Tue, Mar 18, 2025 at 4:00 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >   - even in the -ENOENT case the unreliable bit has already been set
> >     right before the call to kunwind_next_frame_record_meta().
> 
> For this one, do you mean we set state->common.unreliable, but
> failed to propagate it to data.unreliable?

Hm, I hadn't noticed that.  That code is quite the maze.

It's unfortunate there are two separate 'unreliable' variables.  It
looks like consume_state() is the only way they get synced?

How does that work if kunwind_next() returns an error and skips
consume_state()?  Or if kunwind_recover_return_address() returns an
error to kunwind_next()?

What I actually meant was the following:

  do_kunwind()
    kunwind_next()
      kunwind_next_frame_record()
        state->common.unreliable = true;
	kunwind_next_frame_record_meta()
	  return -ENOENT;

Notice that in the success case (-ENOENT), unreliable has already been
set.

Actually I think it would be much simpler to just propagate -ENOENT down
the call chain.  Then no 'unreliable' bits needed.

Like so (instead of original patch):

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c9fe3e7566a6..5713fad567c5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -276,6 +276,7 @@ config ARM64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
+	select HAVE_RELIABLE_STACKTRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2509,4 +2510,3 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
-
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..e227da842bc3 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -277,22 +277,28 @@ kunwind_next(struct kunwind_state *state)
 
 typedef bool (*kunwind_consume_fn)(const struct kunwind_state *state, void *cookie);
 
-static __always_inline void
+static __always_inline int
 do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 	   void *cookie)
 {
-	if (kunwind_recover_return_address(state))
-		return;
+	int ret;
+
+	ret = kunwind_recover_return_address(state);
+	if (ret)
+		return ret;
 
 	while (1) {
 		int ret;
 
 		if (!consume_state(state, cookie))
-			break;
+			return -EINVAL;
+
 		ret = kunwind_next(state);
-		if (ret < 0)
-			break;
+		if (ret)
+			return ret;
 	}
+
+	return -EINVAL;
 }
 
 /*
@@ -324,7 +330,7 @@ do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 			: stackinfo_get_unknown();		\
 	})
 
-static __always_inline void
+static __always_inline int
 kunwind_stack_walk(kunwind_consume_fn consume_state,
 		   void *cookie, struct task_struct *task,
 		   struct pt_regs *regs)
@@ -352,7 +358,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 
 	if (regs) {
 		if (task != current)
-			return;
+			return -EINVAL;
 		kunwind_init_from_regs(&state, regs);
 	} else if (task == current) {
 		kunwind_init_from_caller(&state);
@@ -360,7 +366,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		kunwind_init_from_task(&state, task);
 	}
 
-	do_kunwind(&state, consume_state, cookie);
+	return do_kunwind(&state, consume_state, cookie);
 }
 
 struct kunwind_consume_entry_data {
@@ -387,6 +393,25 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
 }
 
+noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			void *cookie, struct task_struct *task)
+{
+	int ret;
+	struct kunwind_consume_entry_data data = {
+		.consume_entry = consume_entry,
+		.cookie = cookie,
+	};
+
+	ret = kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, NULL);
+	if (ret) {
+		if (ret == -ENOENT)
+			return 0;
+		return ret;
+	}
+
+	return -EINVAL;
+}
+
 struct bpf_unwind_consume_entry_data {
 	bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
 	void *cookie;

