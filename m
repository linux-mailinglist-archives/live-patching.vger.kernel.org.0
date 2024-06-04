Return-Path: <live-patching+bounces-318-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7F98FB5AF
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 16:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C6D51C2106C
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 14:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB9F13D27C;
	Tue,  4 Jun 2024 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R+hWca0I"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314651494A0
	for <live-patching@vger.kernel.org>; Tue,  4 Jun 2024 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717511861; cv=none; b=eV/pqr2tfuJsB3RWlQPycbRE5kVe0DAkV+H0eS+UY6DcxBX849lQqgAGzWnjVDTmj9eZrTaa56u36tsawOmMVnbkl/rAzzVdsbP7yScr4jA/3kkb0OBSAOtMXF7+yphtRWui5O4zwdNWb4mZuRASq0vUA+LWtGnMG2lLkU6dUaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717511861; c=relaxed/simple;
	bh=GSe0K72YrdDKsD9ccEAxSP2G9RITqEcmzRd91s6iNuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRdqijo+HizTpkRFx0ID3RFBiE6dtMX8uktr49UXSc6E1RQqnw5dFOP2lV3uEsbZFGd1i2VTPe1RYP/ifywofZQ7304rNhyFeIsPM+L4lz/bp5rnrIrjeqawiaA0R219hKAAG3c2fIqY8l/ClHVZHlELmvdviHeJb7QN6my+5VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R+hWca0I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717511859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WH8AS3lVorPueuVFarM2V4L81baIisvkBg5pdJlXfEI=;
	b=R+hWca0IJDg6a8uT0Nrk+wMnv8K9cXJyIqzNa6QxPgWZ3R4qn9YReIrgIQahEJ3zAWqOEg
	mnvMsBPTL51NeyYFyFrfCInN5pxPHxHa6+Y3kGghDtdqjWKBkeWcDIXpXeS8502wF76ssX
	/wcogWnCj0vHKi3SSY1Tc297Mg8j1HQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-DCICH841MYyBgLkbsaYwQQ-1; Tue, 04 Jun 2024 10:37:33 -0400
X-MC-Unique: DCICH841MYyBgLkbsaYwQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8963101A521;
	Tue,  4 Jun 2024 14:37:32 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.74])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 440661C1CEAB;
	Tue,  4 Jun 2024 14:37:32 +0000 (UTC)
Date: Tue, 4 Jun 2024 10:37:30 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
Message-ID: <Zl8mqq6nFlZL+6sb@redhat.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <Zloh/TbRFIX6UtA+@redhat.com>
 <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Tue, Jun 04, 2024 at 04:14:51PM +0800, zhang warden wrote:
> 
> 
> > On Jun 1, 2024, at 03:16, Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > 
> > Adding these attributes to livepatch sysfs would be expedient and
> > probably easier for us to use, but imposes a recurring burden on us to
> > maintain and test (where is the documentation and kselftest for this new
> > interface?).  Or, we could let the other tools handle all of that for
> > us.
> How this attribute imposes a recurring burden to maintain and test?
> 

Perhaps "responsibility" is a better description.  This would introduce
an attribute that someone's userspace utility is relying on.  It should
at least have a kselftest to ensure a random patch in 2027 doesn't break
it.

> > Perhaps if someone already has an off-the-shelf script that is using
> > ftrace to monitor livepatched code, it could be donated to
> > Documentation/livepatch/?  I can ask our QE folks if they have something
> > like this.
> 
> My intention to introduce this attitude to sysfs is that user who what to see if this function is called can just need to show this function attribute in the livepatch sysfs interface.
> 
> User who have no experience of using ftrace will have problems to get the calling state of the patched function. After all, ftrace is a professional kernel tracing tools.
> 
> Adding this attribute will be more easier for us to show if this patched function is called. Actually, I have never try to use ftrace to trace a patched function. Is it OK of using ftrace for a livepatched function?
> 

If you build with CONFIG_SAMPLE_LIVEPATCH=m, you can try it out (or with
one of your own livepatches):

# Convenience variable
  $ SYSFS=/sys/kernel/debug/tracing

# Install the livepatch sample demo module
  $ insmod samples/livepatch/livepatch-sample.ko

# Verify that ftrace can filter on our functions
  $ grep cmdline_proc_show $SYSFS/available_filter_functions
  cmdline_proc_show
  livepatch_cmdline_proc_show [livepatch_sample]

# Turn off any existing tracing and filter functions
  $ echo 0 > $SYSFS/tracing_on
  $ echo > $SYSFS/set_ftrace_filter

# Set up the function tracer and add the kernel's cmdline_proc_show()
# and livepatch-sample's livepatch_cmdline_proc_show()
  $ echo function > $SYSFS/current_tracer
  $ echo cmdline_proc_show >> $SYSFS/set_ftrace_filter
  $ echo livepatch_cmdline_proc_show >> $SYSFS/set_ftrace_filter
  $ cat $SYSFS/set_ftrace_filter
  cmdline_proc_show
  livepatch_cmdline_proc_show [livepatch_sample]

# Turn on the ftracing and force execution of the original and
# livepatched functions
  $ echo 1 > $SYSFS/tracing_on
  $ cat /proc/cmdline 
  this has been live patched

# Checkout out the trace file results
  $ cat $SYSFS/trace
  # tracer: function
  #
  # entries-in-buffer/entries-written: 2/2   #P:8
  #
  #                                _-----=> irqs-off/BH-disabled
  #                               / _----=> need-resched
  #                              | / _---=> hardirq/softirq
  #                              || / _--=> preempt-depth
  #                              ||| / _-=> migrate-disable
  #                              |||| /     delay
  #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
  #              | |         |   |||||     |         |
               cat-254     [002] ...2.   363.043498: cmdline_proc_show <-seq_read_iter
               cat-254     [002] ...1.   363.043501: livepatch_cmdline_proc_show <-seq_read_iter


The kernel docs provide a lot of explanation of the complete ftracing
interface.  It's pretty power stuff, though you may also go the other
direction and look into using the trace-cmd front end to simplify all of
the sysfs manipulation.  Julia Evans wrote a blog [1] a while back that
provides a some more examples.

[1] https://jvns.ca/blog/2017/03/19/getting-started-with-ftrace/

--
Joe


