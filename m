Return-Path: <live-patching+bounces-2325-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id scoACb9X12k6MwgAu9opvQ
	(envelope-from <live-patching+bounces-2325-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 09 Apr 2026 09:39:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 841923C7225
	for <lists+live-patching@lfdr.de>; Thu, 09 Apr 2026 09:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2FCF03026C0A
	for <lists+live-patching@lfdr.de>; Thu,  9 Apr 2026 07:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDCA28D8D0;
	Thu,  9 Apr 2026 07:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cBCYfFvr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AC6379EF2
	for <live-patching@vger.kernel.org>; Thu,  9 Apr 2026 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775720199; cv=none; b=sL+vrTDCjR0ajD/MoaSzIZ2zoP0/4NETfcThdGO/0f47evM6NxeTaZTscW18mKQUlwl0AD0eDjMJO0SS11wVJOTmKERRymNdSYOICOjQNajbBaUAtEYm80FSYOg6SutB13VBjKC+P/AnmAJeCWiKrDa2OQRFl0N+/sbF83prrag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775720199; c=relaxed/simple;
	bh=bWM+n0PuIclSzxSg8yrCMqDB9BwasgmhRhRSh6nIcUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gV3GsQeOOWDDqeEp8WoaW9P7YvbVuysXIwszRD34+l0EXxuHqN3Sl92rODTggZhFJIghaThnp5fwCQALyzBKBMoIpvx+BBxdKa7MN4ImPjp+RnhuKcgMryn9LvRq+ma/1jqVGfdkTYgk01NijJrhz+UbBSRj6UhOs9HDyXTeJB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cBCYfFvr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488aa77a06eso8850275e9.0
        for <live-patching@vger.kernel.org>; Thu, 09 Apr 2026 00:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775720195; x=1776324995; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SFIAOrBx/Kk6hQbOqlmoeLP19Ql72j2A2UxB1/jbKYA=;
        b=cBCYfFvrs1geXGepneF48LzQAgmUYgVNSWs7NXsWvzAB3JeKpKS0eBD5D5iChjgId+
         XNhLodDX3OaRT+lCWCtHl9GTXt/zd38gGDyImjK8v9vMtNhrHkXOOMzmj6Fdg2Furs96
         CXJTnqHnFDvRGXQxeCu2v0MTKtkmYolX5VYeXL2UMLxG1wGALEF8xs4oouz47G6tMxnT
         bPdop31V4ZUG1STY5xZiVloB76UIThDBi4FQmNNDVxG/14vJ5zFWqYi6lZgzj2+Q9Oyl
         e5fFK3GsAcb7JbJ94z0YXEon477481XH7PfwuKCFveYFAPEEucllZwaOSVVhuP7X7a4J
         betQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775720195; x=1776324995;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SFIAOrBx/Kk6hQbOqlmoeLP19Ql72j2A2UxB1/jbKYA=;
        b=Q2I1h28YY0d+cLkKkPJF3K6yhflIQ1/aLSK1OxKxd53YsgmJrPRbT+fzgEUf0kVPRV
         DVsF6TOJpk8tC37v6nVzOEeuK/AmkKnVUHsksPTLBHT+V+DNvSWSAxF9tOG7sHQfyhgt
         GWwycf7QX88XKMqX1dwfaysE6EKAP/lAu4/O/HxeGjrB/IN65xeVtWipzsetQ8/avuHK
         /0Amjcl2RiQfpqqi6NqmsU2eW3sIKqLTsVJ60E28Z8bxdHzGDMG9IashYW5iYnS/9qEX
         WM7FSBqfPwKFG/TIscWlWq1jl1Bm/KNs7dq7Bj2CHQT1Y8OJnGe7/sMSU1CWlJx2OA1e
         rrug==
X-Forwarded-Encrypted: i=1; AJvYcCXCA/P+hGNJ+3O+I3DX5aZDHpkrUB1q6qPB0M5RDaELDncOcMV4v8emL4aZ6wMM1vgEZ1OXO09G4JQFOpPR@vger.kernel.org
X-Gm-Message-State: AOJu0YxxwULs+BDatjaHbCoj8KRxxMjcTHp/X6TmMC3uYSRF096NNvT3
	kojUuagpP0pqoVAOMaPZnaV6/K8JbeWDkQLuiHTGYYyy5LDNv2LCBr96cyN13z8U4PM=
X-Gm-Gg: AeBDieuBCJjskpdFvZMg2K9JoPclWnJze6tKsWXnsJOxrpz4DzY0OLDsWtvxXcN+Qp0
	ALTSw9zQI3kHluCi8tWpi2qJ6U6EXjxQCs8mebyXHmConFgKZ8Nl3LhEOgALM+wLX2WgyqWbxl0
	niqg4l/vSmt912sD3SbsCsZ5uTEeBv66DCMzqM2FDk4ady6E8M1UBm1wrv/danxRc9R/fMqzi3D
	DRwU6RgR9o+2L7NoInlkMkIB9zrDsakF8kT4G/pKmaKsxxv4bwwgHy41PCqEVm6QOk9yKUMkQVm
	Q9V1j0IjOf/jV/yAX0mF7ahIljFp4VaGpQ0+FE6xO+MYhsSlN8q0wp1hcH0BD0iW0/wghP3ELD7
	hOqF0hKSecmNb5t8ft9uio14O2HejsksGz5AgnJpaYNMYtmVd7X4uOfqN5UmKSvnG6YQkXGs1C9
	DapBFppBAXsZVJix7rKjFcEWnGNg==
X-Received: by 2002:a05:600c:4753:b0:486:fcc7:d6a with SMTP id 5b1f17b1804b1-4889976eb60mr333821525e9.13.1775720194684;
        Thu, 09 Apr 2026 00:36:34 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cd19ea83sm81192215e9.1.2026.04.09.00.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 00:36:34 -0700 (PDT)
Date: Thu, 9 Apr 2026 09:36:31 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, rostedt@goodmis.org,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	kpsingh@kernel.org, mattbobrowski@google.com, jolsa@kernel.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
	yonghong.song@linux.dev, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to
 klp_patch
Message-ID: <addW_-whBavyHY-Z@pathway.suse.cz>
References: <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com>
 <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
 <adUd0Mojbtrwmeod@pathway.suse.cz>
 <CALOAHbDG9mq1iJv5suct=cqJ+2r8VvJ-dXN=nuvMw0XYqnUjxA@mail.gmail.com>
 <adY_WgA54CDtWBq6@pathway.suse.cz>
 <CAPhsuW42WqGuZ1Z-RG0yzifZ7rh=XKUa5hKb6JxLeTWdc4s4-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW42WqGuZ1Z-RG0yzifZ7rh=XKUa5hKb6JxLeTWdc4s4-A@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2325-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,google.com,kernel.org,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: 841923C7225
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-04-08 11:19:50, Song Liu wrote:
> On Wed, Apr 8, 2026 at 4:43 AM Petr Mladek <pmladek@suse.com> wrote:
> [...]
> > > >
> > > > This is weird semantic. Which livepatch tag would be allowed to
> > > > supersede it, please?
> > > >
> > > > Do we still need this category?
> > >
> > > It can be superseded by any livepatch that has a non-zero tag set.
> >
> > And this exactly the weird thing.
> >
> > A patch with the .replace flag set is supposed to obsolete all already
> > installed livepatches. It means that it should provide all existing
> > fixes and features.
> >
> > Now, we want to introduce a replace flag/set which would allow to
> > replace/obsolete only the livepatch with the same tag/set number.
> > And we want to prevent conflicts by making sure that livepatches with
> > different tag/set number will never livepatch the same function.
> >
> > Obviously, livepatches with different tag/set number could not
> > obsolete the same no-replace livepatch. They would need to livepatch
> > the same functions touched by the no-replace livepatch and would
> > conflict.
> >
> > So, I suggest to remove the no-replace mode completely. It should
> > not be needed. A livepatch which should be installed in parallel
> > will simply use another unique tag/set number.
> 
> I think I see your point now. Existing code works as:
> - replace=false doesn't replace anything
> - replace=true replaces everything
> 
> If we assume false=0 and true=1, it is technically possible to define:
> - replace_set=0 doesn't replace anything
> - replace_set=1 replaces everything
> - replace_set=2+ only replace the same replace_set

Yes. This well describes my point.

> This is probably a little too complicated.
> 
> > > This ensures backward compatibility: while a non-atomic-replace
> > > livepatch can be superseded by an atomic-replace one, the reverse is
> > > not permitted—an atomic-replace livepatch cannot be superseded by a
> > > non-atomic one.
> >
> > IMHO, the backward compatibility would just create complexity and mess
> > in this case.
> 
> Given that livepatch is for expert users, I think we can make this work
> without backward compatibility. But breaking compatibility is always not
> preferred.

I believe that it is acceptable because:

  1. It was always hard to combine no-replace and replace livepatches.
     I wonder if anyone combines them at all.

  2. I believe that nobody tries to load the same livepatch module on
     different kernel versions. Instead, everyone prepares a custom
     livepatch module for each livepatched kernel version/release.

     And the tooling for creating livepatches will need to be updated
     to use "number" instead of "true/false" anyway.

That said, it is easier to always use "0" for non-replace patches
instead of assigning an unique "number" to avoid replacing. But
I do not think that this would justify the complexity of having
different semantic for 0, 1, and 2+ replace_set numbers.

Best Regards,
Petr

