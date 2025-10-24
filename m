Return-Path: <live-patching+bounces-1800-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 353F3C07460
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 18:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57574189CFEE
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 16:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CC6336ECD;
	Fri, 24 Oct 2025 16:21:19 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B062F99AE;
	Fri, 24 Oct 2025 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761322879; cv=none; b=npiSlZAoY8o1JJH4JfAh/pI6hT4GqKvIglmRTEy6dXWFR6y3IIVKLSZOrHILM2yqSaLgaMsNaIVNkN4kG7AqNylZa+EkYgY5npUGo7SrWd0dpQxcq1Cpxahnn5CpRwhe2XRP7kmfFqF0cxdGUInfWfTnAk9a2LGl7uCMmoRC8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761322879; c=relaxed/simple;
	bh=u+RABbfiDwB8KOWWfhGS5SuKdDxH0dOMfXQH4j/bYKc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W039loaF82GXDayc4FWzYP8gH26V8vMJ5QyR9pfH569KZXBpTIJ+H+Z/b6/j7X/O5yG4hNyhLdsoU310gwJcxxKVyiGMEVAO954QAyS2ncwqU3I6V2meoigpqAfauxjdbtq3MdhzEI2iJ4g6vvevwokx0D1MA2d9/ALMRw+NzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D584140D7F;
	Fri, 24 Oct 2025 16:21:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id B02C720011;
	Fri, 24 Oct 2025 16:21:06 +0000 (UTC)
Date: Fri, 24 Oct 2025 12:21:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <songliubraving@meta.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
 "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
 <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
 "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
 "mhiramat@kernel.org" <mhiramat@kernel.org>, Kernel Team
 <kernel-team@meta.com>
Subject: Re: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Message-ID: <20251024122135.3bc668e8@gandalf.local.home>
In-Reply-To: <D4EEB2BC-E87F-4F85-B043-867D4E1ED573@meta.com>
References: <20251024071257.3956031-1-song@kernel.org>
	<20251024071257.3956031-3-song@kernel.org>
	<aPtmThVpiCrlKc0b@krava>
	<D4EEB2BC-E87F-4F85-B043-867D4E1ED573@meta.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5iehismwuy7ybyeiup8rjx4kdg8831rb
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: B02C720011
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+8fP31qr3LzIq83PFv8zCS04TujMrhx5w=
X-HE-Tag: 1761322866-466142
X-HE-Meta: U2FsdGVkX1+Em1zzNVTn6iur8V5TXiUJQ/hQP/DD1sFZjYhCvQoCkvtlpRvySvFk+PnsbFyHgxy157nysWhS6DgSADSIDO5mJJMTqoaeNr0uCqT1Go2BhXQdXjF6vJOonzqt0dU2rInJnFalCAoOd/lZWXVPXD4ab/Ka2ETCf8vfYIZ5TJneAJ7lLLYTtRZfegjiWf/15QsLPyclNhcJmgF8J/5pXEFj+opXzQOqPsEr3XKq9Nisc1DqtElC8P/Hv8SPmB4Z1+TSNl+ytHBkLO7CGOLPf03DwuDnS2H5PF6Dquz7v6vU/PsdMOrBSV7IPVANMViCpSXVm3PvzWby5QnuXUkKW8oZfIByee6FqVXAfMuIGDp96iSBRcqlnbMQ

On Fri, 24 Oct 2025 15:47:04 +0000
Song Liu <songliubraving@meta.com> wrote:

> >> --- a/kernel/trace/ftrace.c
> >> +++ b/kernel/trace/ftrace.c
> >> @@ -2020,8 +2020,6 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
> >> if (is_ipmodify)
> >> goto rollback;
> >> 
> >> - FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);  
> > 
> > why is this needed?  
> 
> This is needed for the modify_ftrace_direct case, because 
> the record already have a direct function (BPF trampoline)
> attached. 

I don't like the fact that it's removing a check for other cases.

It needs to be denoted that this use case is "OK" where as other use cases
are not. That way the check is still there for other cases and only "OK"
for this use case.

Something like this:

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 370f620734cf..51b205bafe80 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1971,7 +1971,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops)
  */
 static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 					 struct ftrace_hash *old_hash,
-					 struct ftrace_hash *new_hash)
+					 struct ftrace_hash *new_hash,
+					 bool update)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec, *end = NULL;
@@ -2020,6 +2021,16 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 				if (is_ipmodify)
 					goto rollback;
 
+				/*
+				 * If this is called by __modify_ftrace_direct()
+				 * then it is only chaning where the direct
+				 * pointer is jumping to, and the record already
+				 * points to a direct trampoline. If it isn't
+				 * then it is a bug to update ipmodify on a direct
+				 * caller.
+				 */
+				FTRACE_WARN_ON(!update &&
+					       (rec->flags & FTRACE_FL_DIRECT));
 				/*
 				 * Another ops with IPMODIFY is already
 				 * attached. We are now attaching a direct
@@ -2067,14 +2078,14 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 	return -EBUSY;
 }
 
-static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
+static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops, bool update)
 {
 	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 
 	if (ftrace_hash_empty(hash))
 		hash = NULL;
 
-	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
+	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash, update);
 }
 
 /* Disabling always succeeds */
@@ -2085,7 +2096,7 @@ static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
 	if (ftrace_hash_empty(hash))
 		hash = NULL;
 
-	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
+	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH, false);
 }
 
 static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
@@ -2099,7 +2110,7 @@ static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
 	if (ftrace_hash_empty(new_hash))
 		new_hash = NULL;
 
-	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
+	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash, false);
 }
 
 static void print_ip_ins(const char *fmt, const unsigned char *p)
@@ -3059,7 +3070,7 @@ int ftrace_startup(struct ftrace_ops *ops, int command)
 	 */
 	ops->flags |= FTRACE_OPS_FL_ENABLED | FTRACE_OPS_FL_ADDING;
 
-	ret = ftrace_hash_ipmodify_enable(ops);
+	ret = ftrace_hash_ipmodify_enable(ops, false);
 	if (ret < 0) {
 		/* Rollback registration process */
 		__unregister_ftrace_function(ops);
@@ -6131,7 +6142,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	 * ops->ops_func for the ops. This is needed because the above
 	 * register_ftrace_function_nolock() worked on tmp_ops.
 	 */
-	err = ftrace_hash_ipmodify_enable(ops);
+	err = ftrace_hash_ipmodify_enable(ops, true);
 	if (err)
 		goto out;
 

-- Steve

