Return-Path: <live-patching+bounces-307-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D48518D699B
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 21:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 126CF1C25437
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 19:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C0A17F4E4;
	Fri, 31 May 2024 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhrIhl5p"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9297A17E47D
	for <live-patching@vger.kernel.org>; Fri, 31 May 2024 19:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717182986; cv=none; b=P8WwvxtjJdoLztW9vPf+Pd7sIJNAVSgwZLmngsueVAr8fcYqXkDMp1fOZG3rd0TOQNXw5qsm1PKatY0ipxnXUsMvWkzgIWSA2UgN6ck8etEIC8QjWYMM67AXXIoG7GcgFNlas4Gb2e6op8vIclWAnCrzAsC24Ga7Ynmwd1S8kEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717182986; c=relaxed/simple;
	bh=xnPT9cCYR0XzEVJxY7VD2z3dllt5tDYentIhPbVk60I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoZ3iptLuc0Er68RhDNjSRYGoqTrGZ8tMC9F6k5yI3/mGLCtHeaYBg45pM/iOkPHAc4G/u95fG6Ct63PqgpglALFrJmLlBKqUffljnHndu5h9tBhuvFzhmAKkL0bWXuPPRvIwKIdoYmAwTBEmBJadx1OJG4FU96DEFPuok2n1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bhrIhl5p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717182983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VLBzlF00otJAGz7fWp1w9pHDKelUe6skH+LZzm/YKTI=;
	b=bhrIhl5p3TunyxoA4Fe12TrAdbSy5JGrW4anXwJzYadLC1FUH9iyZTDM6V6nTb0h+PSOJX
	7iyTVCy6quW3mk6IZOpc9EJ14SgGbgNUXXHB3pwC21/tGzlOnPLgoK126i9L7eMFOuB5Rz
	3jfoQuyBe5EMhBKqkJDHbjeVhJPSf+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-HzRcG1Q6O_ilqftIPjag6A-1; Fri, 31 May 2024 15:16:16 -0400
X-MC-Unique: HzRcG1Q6O_ilqftIPjag6A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E1F85A58C;
	Fri, 31 May 2024 19:16:15 +0000 (UTC)
Received: from redhat.com (unknown [10.22.18.140])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57DDC40004D;
	Fri, 31 May 2024 19:16:15 +0000 (UTC)
Date: Fri, 31 May 2024 15:16:13 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: zhang warden <zhangwarden@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
Message-ID: <Zloh/TbRFIX6UtA+@redhat.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, May 21, 2024 at 08:34:46AM +0200, Miroslav Benes wrote:
> Hello,
> 
> On Mon, 20 May 2024, zhang warden wrote:
> 
> > 
> > 
> > > On May 20, 2024, at 14:46, Miroslav Benes <mbenes@suse.cz> wrote:
> > > 
> > > Hi,
> > > 
> > > On Mon, 20 May 2024, Wardenjohn wrote:
> > > 
> > >> Livepatch module usually used to modify kernel functions.
> > >> If the patched function have bug, it may cause serious result
> > >> such as kernel crash.
> > >> 
> > >> This is a kobject attribute of klp_func. Sysfs interface named
> > >> "called" is introduced to livepatch which will be set as true
> > >> if the patched function is called.
> > >> 
> > >> /sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called
> > >> 
> > >> This value "called" is quite necessary for kernel stability
> > >> assurance for livepatching module of a running system.
> > >> Testing process is important before a livepatch module apply to
> > >> a production system. With this interface, testing process can
> > >> easily find out which function is successfully called.
> > >> Any testing process can make sure they have successfully cover
> > >> all the patched function that changed with the help of this interface.
> > > 
> > > Even easier is to use the existing tracing infrastructure in the kernel 
> > > (ftrace for example) to track the new function. You can obtain much more 
> > > information with that than the new attribute provides.
> > > 
> > > Regards,
> > > Miroslav
> > Hi Miroslav
> > 
> > First, in most cases, testing process is should be automated, which make 
> > using existing tracing infrastructure inconvenient.
> 
> could you elaborate, please? We use ftrace exactly for this purpose and 
> our testing process is also more or less automated.
> 
> > Second, livepatch is 
> > already use ftrace for functional replacement, I don’t think it is a 
> > good choice of using kernel tracing tool to trace a patched function.
> 
> Why?
> 
> > At last, this attribute can be thought of as a state of a livepatch 
> > function. It is a state, like the "patched" "transition" state of a 
> > klp_patch.  Adding this state will not break the state consistency of 
> > livepatch.
> 
> Yes, but the information you get is limited compared to what is available 
> now. You would obtain the information that a patched function was called 
> but ftrace could also give you the context and more.
> 
> It would not hurt to add a new attribute per se but I am wondering about 
> the reason and its usage. Once we have it, the commit message should be 
> improved based on that.
> 

I agree with Miroslav about using ftrace, or Dan in the other thread
about using gcov if even more granular coverage is needed.

Admittedly, I would have to go find documentation to remember how to do
either, but at least I'd be using well-tested facilities designed for
this exact purpose.

Adding these attributes to livepatch sysfs would be expedient and
probably easier for us to use, but imposes a recurring burden on us to
maintain and test (where is the documentation and kselftest for this new
interface?).  Or, we could let the other tools handle all of that for
us.

Perhaps if someone already has an off-the-shelf script that is using
ftrace to monitor livepatched code, it could be donated to
Documentation/livepatch/?  I can ask our QE folks if they have something
like this.

Regards,

--
Joe


