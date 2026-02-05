Return-Path: <live-patching+bounces-1989-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFvJCfS8hGnG4wMAu9opvQ
	(envelope-from <live-patching+bounces-1989-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 16:53:24 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73568F4CE3
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 16:53:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AE7C83005335
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 15:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D2F426D20;
	Thu,  5 Feb 2026 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J48VPXBy"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364D4421F11
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306799; cv=none; b=Yp4ogWnxOIC7ckeiiAr+QIEndXQmCh0CqMSAZ5ZUjECQS/tVCcj8ObWFd2dLaHdx8xaWzjj/lJkNyICmkzd7NxOstjsbR3qkDfa3NBH3Wxxk9/ahK4aC05hHYMIfwZWXfqrxbyZYvvXcfGOcP3dPYoCXx7TubLumANTm3ayaHr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306799; c=relaxed/simple;
	bh=BvNQP8toLJCzP4InBeCg66IkoQckS9Gld5kou8pVDFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZz7TxytD9O8g7iFGpGEJo0hQ6ZXNe+obhFX2gPqg0+1K8ASvjayas9FIR88qf6JcPFazwJiFtFGqtaiklQdWwIJxHbk6wE6hdxPI1+CP9YmJbfNQp1ih0Vm8wZV3M3a7W0s0u7EzRmosRDZ/x+zqvcFiWdNNjh3LuslaR9pW7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J48VPXBy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770306798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QRJieIvLVa5p1iEpaxUcQ1NO7fwzTV6dGvyMy85+XqI=;
	b=J48VPXByhYmpYTnYKV0XccwiHrKczN1/KI88KTNNS+GJjQsvG9iAnGtUuHknlBOTY849W5
	82ujdHiTynHKtbSq/KJvtOFD7U4dGh65kxiq4YjBDcWZwIvT/pvmRb1hi1L3Q3DOeFE8P6
	2wJwmPm+0GXFqPOpJkhNcLjx8csFA4Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-eB5tZZxfNeqDRKBfD0Y0jA-1; Thu,
 05 Feb 2026 10:53:10 -0500
X-MC-Unique: eB5tZZxfNeqDRKBfD0Y0jA-1
X-Mimecast-MFC-AGG-ID: eB5tZZxfNeqDRKBfD0Y0jA_1770306789
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48CE418002E6;
	Thu,  5 Feb 2026 15:53:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D54B718003F6;
	Thu,  5 Feb 2026 15:53:07 +0000 (UTC)
Date: Thu, 5 Feb 2026 10:53:05 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 1/5] objtool/klp: Fix mkstemp() failure with long paths
Message-ID: <aYS84XTYTrjqLcci@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-2-joe.lawrence@redhat.com>
 <jwj6k6bbvga3uaaj2hhtau256t7mvcg65wsv5cpsdrx7cpt4zd@knbng27js6t5>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jwj6k6bbvga3uaaj2hhtau256t7mvcg65wsv5cpsdrx7cpt4zd@knbng27js6t5>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1989-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 73568F4CE3
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 08:47:41AM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 03, 2026 at 09:51:36PM -0500, Joe Lawrence wrote:
> > @@ -1219,13 +1221,17 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
> >  
> >  	base = basename(base);
> >  
> > -	tmp_name = malloc(256);
> > +	tmp_name = malloc(PATH_MAX);
> 
> The allocation size can be more precise with something like
> 
> 	tmp_name = malloc(strlen(name) + 8);
> 
> Also, I'm scratching my head at the existing code and wondering why we
> are splitting out the dirname() and the basename() just to paste them
> back together again??  Can you simplify that while you're at it?
> 
> >  	if (!tmp_name) {
> >  		ERROR_GLIBC("malloc");
> >  		return NULL;
> >  	}
> >  
> > -	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
> > +	path_len = snprintf(tmp_name, PATH_MAX, "%s/%s.XXXXXX", dir, base);
> > +	if (path_len >= PATH_MAX) {
> > +		ERROR_GLIBC("snprintf");
> > +		return NULL;
> > +	}
> 
> Checking for all the snprintf() cases can be a pain so we have a
> snprintf_check() for a streamlined error checking experience.
> 

Ah, completely missed that, thanks for pointing out.  I'll incorporate
both suggestions into v3.

--
Joe


