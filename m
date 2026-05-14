Return-Path: <live-patching+bounces-2811-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPkgM+R3BWopXgIAu9opvQ
	(envelope-from <live-patching+bounces-2811-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 09:21:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F8053ED22
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 09:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52A693016ED7
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 07:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FD23D7D83;
	Thu, 14 May 2026 07:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K9XVPXyr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4503D7A19
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 07:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778743265; cv=none; b=SLHOxzaP4KKfrrLtsjBPHbMLi4B1mExXVmaIGWnNshZR/GOY2MAfWYicN4WeU0yPxTGIM2dWqMSbHCPpz5CapTxVtLdhieSElrNQYEKo6nKsDwKAoYfXh4So+8VXgNMLD8Smp3HgxfA2iN79SutLeU+erUNRg/vF7qZZpwhUWkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778743265; c=relaxed/simple;
	bh=nXlC69mjeia8IpbITBoM6hWK0c+I1rwCL7gHRpi0eNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2Rg7eo+REqlkJJnETb6Ck+uuzIMT0dB57+ADVdtjoNSVVdF9GP1FKLdHaoIQ53UkTXolvIQk9NNaBkMDuUpXMcRHK7X+wvdRig3q3z0ffRJq68LDUtOgbNgN/AjGbzDMVhm5gVH6lNra69nzf88+ggPN/1IXWEsCQbjh7YdluU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K9XVPXyr; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488ad135063so61606575e9.0
        for <live-patching@vger.kernel.org>; Thu, 14 May 2026 00:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778743262; x=1779348062; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GLDl5+jeWVEPVUIjYt/gD1wOZBUbuKJWiTwRWkSgoOQ=;
        b=K9XVPXyrTxQBuVx3yewDWtaAMPw1g+FDDo+UxEQ78+ME1B8CPK6DtqsDtdX/g3w9CW
         ueKW44ZMA3vH7FAcjfD/1VhJ1irJ5qf9Po2cmcdiq1y2Ap4v89qKIHqMZ52hBVZo4x8w
         L2zvFvoVi2lQrceeFhDWMhkRmFbXKuQetRcmPLtx1gYiaGF0a4e38CpJ+8VNtQghWOJN
         GoJRhGYliJOuOKSddvj+4P4jdybxTGxqIch6Lqx6Segn/d2JT1KvdMKMPx4jMWBU1MgK
         Iapqq5V3un8tYHU5n6ZR5R/wJio1Y3rDgjiPfWpPdSJc0FNW4KFs8mdAuZjjAKSTNidJ
         YPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778743262; x=1779348062;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GLDl5+jeWVEPVUIjYt/gD1wOZBUbuKJWiTwRWkSgoOQ=;
        b=MCQwKlaFnvCp1rwtE0tMqmvyfuIvIRR14VStvKUknf3wbWeFFa8KAMkqZMbwH0DvF9
         UWp7loTOYe738riuFimxS6q6XMr9PUNpBtCPKhU+mQrRB4BtslYEyJ4I725245+OYpoL
         vODaW9E1ERTXT5PAb+4w0xMRBnMKPwVVlomTZp1zI/Hd+VEiTd8iIYyfYDHRmLLeSo7j
         KC/qSBohPpCoPrvftVrdLsniIqtCKDRhh8J35qBL02wOd2IAN1eNTwhxSPNA6ABo12GS
         gDyCA2LYDYdhO0I2Y8xfQ4TMFXf9vx5AC+53A5ECSJp1l49HFGg8owIWEDN0lHnVY4dF
         x07Q==
X-Forwarded-Encrypted: i=1; AFNElJ+8jJ8jC3G47xTb729uI+4HMMTw9ygeTok6R0LOchXimPIUKHkVYZjQg8+ZVxNElCxrlN4cnpLmaUJ9fxZb@vger.kernel.org
X-Gm-Message-State: AOJu0YzaimyVpiCMLEASAvn63wl4bU1VdAl7622rdfpySfRxt5I6EByG
	2PDtpTnHAOZUhSCtjUIaYhucLF70V6QPKJmRgIanZ8dKnv6k7X2yEu8MYbHRsgRhSGs=
X-Gm-Gg: Acq92OGHqw8VQNSCDKwrrZ1a0mKMb7bziVA/xjWi8TdWHIMySH+9uEkf5YhmBye9rDI
	keydrf55Cua3TU9w3n3RHAtU2226qBmlty2fiLnswEhX8H3mZBmLheddJKJ9XfEvUSf6adiwvqB
	8cLXYVYAdcb9hLS+XiEFoll/R3TV6SnshTdVmzuF1irhh0i94XSxD007oP5J9EUhxFkmJmsaT2U
	yVmvBun2uhAsvlzgmdlceKXDpyaCiumyLdN1MxdLxSbmQt9DWd3BjUicDI4tPk9hOOCpRXIACqZ
	vHhk907jP7HkySV3Pc4b+GS7CFmeioRD8et4KQKLyt6XH0MwKeWoD2re+u/G64CIqMHGVlVktSD
	TSQMQNUVgK6z/xBVfe89RZBAiLzFJNrjw7/GBqNv4EPB+Uqo+K6EFtVtCH08HUexeUj8ZIIm4ep
	wTHsiWSHY2+yQjCHa4X+mmiTHgRI2xkjX0k94e
X-Received: by 2002:a05:600c:c84:b0:48a:65ad:1881 with SMTP id 5b1f17b1804b1-48fce9eac86mr94051245e9.13.1778743262248;
        Thu, 14 May 2026 00:21:02 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ec39806sm4430372f8f.9.2026.05.14.00.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 00:21:01 -0700 (PDT)
Date: Thu, 14 May 2026 09:21:00 +0200
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Song Liu <song@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Subject: Re: Sashiko patch review for live-patching?
Message-ID: <agV33GZsjwQjZNGb@pathway.suse.cz>
References: <agSjM8dxgnV9QQaf@redhat.com>
 <CAPhsuW6CgBtEGAK+E0n7+tnLAWNPTEuvnAo0vtQsbMVBb6htFw@mail.gmail.com>
 <ju3k5mp22u37l4m27xygqce2sh2nczwckvmk3exkldk5365csx@q53zbumzj33t>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ju3k5mp22u37l4m27xygqce2sh2nczwckvmk3exkldk5365csx@q53zbumzj33t>
X-Rspamd-Queue-Id: 27F8053ED22
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2811-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.com:dkim]
X-Rspamd-Action: no action

On Wed 2026-05-13 12:47:13, Josh Poimboeuf wrote:
> On Wed, May 13, 2026 at 10:17:51AM -0700, Song Liu wrote:
> > Hi Joe,
> > 
> > On Wed, May 13, 2026 at 9:13 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > >
> > > Hello live-patching maintainers,
> > >
> > > I've noticed several references to the Sashiko (https://sashiko.dev/)
> > > kernel review bot on this list and was wondering if there is interest in
> > > adding live-patching to the mailing lists Sashiko tracks.
> > 
> > I think it is a great idea. AFAICT, these bots add a lot of values in the
> > code reviews.
> 
> +1
> 
> > > Integration appears straightforward: we can submit an MR to add our
> > > entry to sashiko-k8s.yaml and customize the bot's email behavior in
> > > email_policy.toml.
> > >
> > > Full Sashiko Maintainer documentation is available here:
> > > https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md
> > >
> > > Personally, I would vote to set reply_to_author.  I don't have a strong
> > > opinion on the other custom options, provided that the CC list is opt-in
> > > rather than simply mirrored from the MAINTAINERS::LIVE PATCHING file.
> > > Either way, I've found the Sashiko web interface very helpful in patch
> > > review.
> > 
> > Given the relatively low volume of patches to the livepatch mail list, I
> > think we can use reply_all. But if folks prefer reply_to_author instead,
> > we sure can use the cc list.
> 
> I would vote reply_all.  The signal/noise ratio isn't perfect, but it's
> high enough to be useful in many cases.  That way the
> maintainers/reviewers are aware of any potential issues, and it avoids
> duplicating review work and fragmenting conversations.

I agree. And it might even motivate us to update the subsystem
specific review prompts so that the review gets improved over time.

Best Regards,
Petr

