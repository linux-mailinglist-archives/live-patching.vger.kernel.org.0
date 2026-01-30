Return-Path: <live-patching+bounces-1943-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +I5lHd8WfWkGQQIAu9opvQ
	(envelope-from <live-patching+bounces-1943-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:38:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDB3BE75C
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D0B19300D703
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AF7329E7F;
	Fri, 30 Jan 2026 20:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jBONvw7W"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743A24EF8C
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769805531; cv=none; b=G9VWUd+F+4P84WRYygxHrtq9B+92oXzuSO7NJih1+/CpDOc85SlXAPM5+20/3ejpg8QZeY8ROl1G6VEm/e9adxlB/4ypZqvDkOPg42IU+6zfo0tzbxkOf7hsJQIixB+HIFwlhtdsbk9kQeWntZjXUWt9hVs7Oe7RL6yPQ3m+9I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769805531; c=relaxed/simple;
	bh=P9+Ep15JIb9rZ2u4IMcS5BRA3O8o5QZtXGs9daeDfBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z1j8GSV5oykTuMTHHGOhU78badltfszTqSMiF+vDB2FNbAVZ99VMO+ieP8hb6OJlrmfIeBL/fDq6+WvsJZ6yE3L0IIKN1B1aAU9FeUWQJKcHp1NVwG85MhZA8UnbWS4dd+24D8RFKfsSYa8G34BnbuCGWzqFCo12HOmOyYcGVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jBONvw7W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769805528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o4SAnJqarmKCs8WpruaJML1Ukfl4ZDJBGmVYHMPtOLo=;
	b=jBONvw7WrEBX8SbVVooEr6TbUcLpnLgKTwUx3N8oZu+k91s5iVApcSY23lzuoP4BFdWhhn
	9AHt1kb31fp25G6GYpkbOCLWYX3/ZV67JFyLlHbp9T7+D9EoN4jtqU0ZZ7ph5Jpi6CuNDd
	Y4bvQ1tzmXlcvJBGWmT5J1gjHiIHOQE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-Xu692qhPOUqi-xUl_50v3A-1; Fri,
 30 Jan 2026 15:38:45 -0500
X-MC-Unique: Xu692qhPOUqi-xUl_50v3A-1
X-Mimecast-MFC-AGG-ID: Xu692qhPOUqi-xUl_50v3A_1769805524
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1503D19560B5;
	Fri, 30 Jan 2026 20:38:44 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E16F19560A2;
	Fri, 30 Jan 2026 20:38:42 +0000 (UTC)
Date: Fri, 30 Jan 2026 15:38:40 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply
 --recount
Message-ID: <aX0W0JWRkLbuQpGY@redhat.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com>
 <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1943-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DCDB3BE75C
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:05:35PM -0800, Josh Poimboeuf wrote:
> On Fri, Jan 30, 2026 at 12:59:48PM -0500, Joe Lawrence wrote:
> > Consider a patch offset by a line:
> > 
> >   $ cat combined.patch
> >   --- src.orig/fs/proc/cmdline.c	2022-10-24 15:41:08.858760066 -0400
> >   +++ src/fs/proc/cmdline.c	2022-10-24 15:41:11.698715352 -0400
> >   @@ -6,8 +6,7 @@
> >   
> >    static int cmdline_proc_show(struct seq_file *m, void *v)
> >    {
> >   -	seq_puts(m, saved_command_line);
> >   -	seq_putc(m, '\n');
> >   +	seq_printf(m, "%s livepatch=1\n", saved_command_line);
> >    	return 0;
> >    }
> >   
> >   --- a/fs/proc/version.c
> >   +++ b/fs/proc/version.c
> >   @@ -9,6 +9,7 @@
> >   
> >    static int version_proc_show(struct seq_file *m, void *v)
> >    {
> >   +	seq_printf(m, "livepatch ");
> >    	seq_printf(m, linux_proc_banner,
> >    		utsname()->sysname,
> >    		utsname()->release,
> > 
> > GNU patch reports the offset:
> > 
> >   $ patch --dry-run -p1 < combined.patch
> >   checking file fs/proc/cmdline.c
> >   Hunk #1 succeeded at 7 (offset 1 line).
> >   checking file fs/proc/version.c
> > 
> > It would pass the initial check as per validate_patches():
> > 
> >   $ git apply --check < combined.patch && echo "ok"
> >   ok
> > 
> > But later fail the patch application by refresh_patch():
> > 
> >   $ git apply --check --recount < combined.patch
> >   error: patch failed: fs/proc/cmdline.c:6
> >   error: fs/proc/cmdline.c: patch does not apply
> 
> Hm, isn't the whole point of --recount that it ignores the line numbers?
> Or does it just ignore the numbers after the commas (the counts)?
> 

I don't know exactly.  As I continue digging into the test that sent me
down this path, I just found that `git apply --recount` doesn't like
some output generated by `combinediff -q --combine` even with NO line
drift... then if I manually added in corresponding diff command lines
(to make it look more like a .patch file generated by `diff -Nu`), ie:

  diff -Nu src.orig/fs/proc/array.c src/fs/proc/array.c     <---
  --- src.orig/fs/proc/array.c
  +++ src/fs/proc/array.c

Suddenly `git apply --recount` is happy with the patch.

So I suspect that I started with git not liking the hunks generated by
combinediff and drove it to the rebase feature, which solves a more
interesting problem, but by side effect smoothed over this format
issue when it recreated the patch with git.

Anyway, I think this patch still stands on it's own: perform the same
apply/revert check as what would happen in the fixup steps to fail
faster for the user?

--
Joe 


