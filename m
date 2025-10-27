Return-Path: <live-patching+bounces-1820-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4D3C0F814
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 18:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A248F19A4EB0
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 17:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2784B313E1C;
	Mon, 27 Oct 2025 17:00:47 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FC0314D1F;
	Mon, 27 Oct 2025 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761584447; cv=none; b=Lv6lfyJ/IYSoAllPX+D16pI4m9gQk92CLxABtAnPL6GC9l3E/Y86WSaWthXImINYGLsIJwlh0rf4wrRhQIJn4Pv1fBQ7sD1JldhM38y+k/P6/8CLb2vuYiy7fNMvrgNdeZEMiVhjedBnmCbVKtNq0uuDObuNZcptNdjHO5G+oTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761584447; c=relaxed/simple;
	bh=AW+uBVkZ7blD+z57BRlsNkIK1OZ57j/FX/0q3xlVmn8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4wrUgSI3pMyGM0Nz/CDQ2xHJ4wNqFJWnTqlN7NL+5LR12q0HzRf7wSK5iKs6c3+m8/ESCCqTCD94YLqW+ZEkniZbhzfK8QGDPjoiSYLvuJVKeSUCtodzUTDGzk8JD5tf9hrXOaUJIEIiAvPwxlbZrQEmfx+w7A40MG4cbZpweY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23D331A01E6;
	Mon, 27 Oct 2025 17:00:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 969A81E;
	Mon, 27 Oct 2025 17:00:33 +0000 (UTC)
Date: Mon, 27 Oct 2025 13:01:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <song@kernel.org>
Cc: bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, andrey.grodzovsky@crowdstrike.com, mhiramat@kernel.org,
 kernel-team@meta.com, olsajiri@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Message-ID: <20251027130109.4065026f@gandalf.local.home>
In-Reply-To: <20251026205445.1639632-2-song@kernel.org>
References: <20251026205445.1639632-1-song@kernel.org>
	<20251026205445.1639632-2-song@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 969A81E
X-Stat-Signature: zgpiqdfq3xfpp98kxzc8t1ikg1w19hnt
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/BKfmPXZzH1N7RsBVffcbvXnVHMI4eHCI=
X-HE-Tag: 1761584433-530337
X-HE-Meta: U2FsdGVkX1+B5Z7vjqW2B2UTVfiwYjWO0dlLJFfGF914RMDSTZeP003v7Prmm4tVy5gEAL3JvLrTpF1XXJJuxmC8DA4mK5JGwr6pgY3Ro+zNNLRlgxUgH9FF3WVN1aXzne/2/MCU4xcYZq66wRhu1n5XMuIWQd2rzjsd/Tvhb9Qlf0XBMVqpZDphETaiIEZDleh2RVZZSNSwUEPpfcOzG7uLxhNOOoG/y2G0xHEihfOzdoha0ZWm2ZTo+ZhoAZjX2WrPcWk3iT02vzJN8Nhf2ZL5ZmETsNx6PXnLqkEqB28lTk6kjKWtRI9VIQDgDVGHl+A9P0y7u49+pmNM30JAIkuS7c4IyT6v

On Sun, 26 Oct 2025 13:54:43 -0700
Song Liu <song@kernel.org> wrote:

> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -6048,6 +6048,12 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
>  	ops->direct_call = addr;
>  
>  	err = register_ftrace_function_nolock(ops);
> +	if (err) {
> +		/* cleanup for possible another register call */
> +		ops->func = NULL;
> +		ops->trampoline = 0;
> +		remove_direct_functions_hash(hash, addr);
> +	}
>  

As you AI bot noticed that it was missing what unregister_ftrace_direct()
does, instead, can we make a helper function that both use? This way it
will not get out of sync again.

static void reset_direct(struct ftrace_ops *ops, unsigned long addr)
{
	struct ftrace_hash *hash = ops->func_hash->filter_hash;

	ops->func = NULL;
	ops->trampoline = 0;
	remove_direct_functions_hash(hash, addr);
}

Then we could have:

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0c91247a95ab..51c3f5d46fde 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6062,7 +6062,7 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	err = register_ftrace_function_nolock(ops);
 	if (err)
-		remove_direct_functions_hash(hash, addr);
+		reset_direct(ops, addr);
 
  out_unlock:
 	mutex_unlock(&direct_mutex);
@@ -6095,7 +6095,6 @@ EXPORT_SYMBOL_GPL(register_ftrace_direct);
 int unregister_ftrace_direct(struct ftrace_ops *ops, unsigned long addr,
 			     bool free_filters)
 {
-	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	int err;
 
 	if (check_direct_multi(ops))
@@ -6105,13 +6104,9 @@ int unregister_ftrace_direct(struct ftrace_ops *ops, unsigned long addr,
 
 	mutex_lock(&direct_mutex);
 	err = unregister_ftrace_function(ops);
-	remove_direct_functions_hash(hash, addr);
+	reset_direct(ops, addr);
 	mutex_unlock(&direct_mutex);
 
-	/* cleanup for possible another register call */
-	ops->func = NULL;
-	ops->trampoline = 0;
-
 	if (free_filters)
 		ftrace_free_filter(ops);
 	return err;

-- Steve

