Return-Path: <live-patching+bounces-1942-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AL/DMRQRfWmUQAIAu9opvQ
	(envelope-from <live-patching+bounces-1942-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:14:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 361BDBE551
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C91873011F01
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23528316904;
	Fri, 30 Jan 2026 20:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxDFfuT3"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E22F3195EC
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769804050; cv=none; b=YrRF5+8NSKXkamcVZRSO0x7pQFsfw4YAYGeOO250cJI5sDneDEtOeE/bwOhAT1lvp8p6mhE85RQzOQBjlxIvvzhbmcHmD9Sn0isWldGkZ1d9C8oDcPyvPYuOq9/5dk6mW8bRIgO0O5Q72uTDjfmXBnvkbuE31WzR0JGIEzhI59M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769804050; c=relaxed/simple;
	bh=yteR4fdXQRm3w9sdmCZvWU8TKS1ld4w6B2zpss9vJ7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/7C+BOxJX8eswtHzdb/mjBlseuZbNz3Lv9OQ9huP7CEi4RAUoWuW/JLc/fuJHw5dZrVPg6IyXSaRwx/E5eup7Dwj1YLbmiUDgSXq7Wr/RTnIsCsAzqYhI9sOvTSwdjQGRHrJVBPvHlK2MUGDF61R5tf7R2+Fy0cKxO4POlxYOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LxDFfuT3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769804047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3yT0KzenPTxpM8Qyn2YBwY01sW4FIb9m3iNxRNxS4gs=;
	b=LxDFfuT35Z82kQ/PSYodavdYPIX1LWNpFq7jiC+90Duf5VcFnj3ZTmg2jUipxm0CuDXo1r
	PKNVNEBTuqUxLbQpQeq9S5Iw04Zg/GsR6YbDiSJkFdF2pziKJVN8mPNE4/vnrqpEI9Z+bE
	PTYnYC7M+AatXgkMgFG8P4/RVvVfQV8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-k-yF4adPNwGNCR1p_pjzAQ-1; Fri,
 30 Jan 2026 15:14:06 -0500
X-MC-Unique: k-yF4adPNwGNCR1p_pjzAQ-1
X-Mimecast-MFC-AGG-ID: k-yF4adPNwGNCR1p_pjzAQ_1769804043
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 957361800370;
	Fri, 30 Jan 2026 20:14:03 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C9DB1800109;
	Fri, 30 Jan 2026 20:14:01 +0000 (UTC)
Date: Fri, 30 Jan 2026 15:13:59 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Message-ID: <aX0RBzV5X1lgQ2ec@redhat.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com>
 <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1942-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 361BDBE551
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 11:58:06AM -0800, Song Liu wrote:
> On Fri, Jan 30, 2026 at 10:00 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> [...]
> > @@ -807,6 +906,8 @@ build_patch_module() {
> >  process_args "$@"
> >  do_init
> >
> > +maybe_rebase_patches
> > +
> >  if (( SHORT_CIRCUIT <= 1 )); then
> 
> I think we should call maybe_rebase_patches within this
> if condition.
> 

Hi Song,

Ah yeah I stumbled on this, probably overthinking it:

  - we want to validate rebased patches (when requested)
  - validate_patches() isn't really required for step 1 (building the
    original kernel) but ...
  - it's nice to check the patches before going off and building a full
    kernel
  - the patches are needed in step 2 (building the patched kernel) but ...
  - patch validation occurs in step 1

so given the way the short circuiting works, I didn't see a good way to
fold it in there.  The user might want to jump right to building the
patched kernel with patch rebasing.  Maybe that's not valid thinking if
the rebase occurs in step 1 and they are left behind in klp-tmp/ (so
jumping to step 2 will just use the patches in the scratch dir and not
command line?).  It's Friday, maybe I'm missing something obvious? :)

--
Joe


