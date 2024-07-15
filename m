Return-Path: <live-patching+bounces-393-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D679931BB8
	for <lists+live-patching@lfdr.de>; Mon, 15 Jul 2024 22:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D2681F222D0
	for <lists+live-patching@lfdr.de>; Mon, 15 Jul 2024 20:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AFC56446;
	Mon, 15 Jul 2024 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnTgwGJ5"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BCD282FD
	for <live-patching@vger.kernel.org>; Mon, 15 Jul 2024 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721074836; cv=none; b=jETBH5LZsmF3po2z+VNL/i2eiPt1scWC6KU1wt6zB2NmJD/iZZFc+6nIxxBGK+VtbxzCAgqHrID5WgJXkxOr/L+pi/T+DWcy2VTZ6iW1AaoroQbToRMDmVo4uc3iD1EOjeI0fWJY2qNp8UroOHgDxq49r3OMtb96sVHW+fTBjPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721074836; c=relaxed/simple;
	bh=CwrY2FshVSVx5FVVJ9y+Fqf6n6aTUdtvjcswh2OaSB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R42VCg1TaVXeTpzr/VELuaRDI3Z6aDKgGvHPnjsPNWNtO7mtwEj+lPvFGZio0O4/f/AWO5a8EUHuedfhlHbcnKqcDKYjFmlTswoTztENjcBTHz6+UBtt6AyRwnjQKJGEJfnXKj/h/SxwjIBszxHcuoRacDl+JIxb9k5+W0RPG+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnTgwGJ5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721074833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SP4YcBA7vkQmeb7h06CQvLwPfDmjns8w55N3acvbcSM=;
	b=XnTgwGJ5A71nR9cb5b2ojnT3zf3pJsWePtEVwhgvMnuBhLa23IIrgAH2ekVHu+nyE0k/Uc
	Glt/A5aBMzBdqxAGperyMfSbQyxP/tBot0PysxAvxfmb1Zr+ObSPy1DaWhkzFTkSv4RRBD
	B5TfCsJYKFFOfbFhXvzmvS05X3jz+Vs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-UpSTYXdaMXuG7FCP4ZMJkw-1; Mon,
 15 Jul 2024 16:20:31 -0400
X-MC-Unique: UpSTYXdaMXuG7FCP4ZMJkw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0C5A1955F43;
	Mon, 15 Jul 2024 20:20:29 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.89])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51AD91955D44;
	Mon, 15 Jul 2024 20:20:28 +0000 (UTC)
Date: Mon, 15 Jul 2024 16:20:25 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: raschupkin.ri@gmail.com
Cc: live-patching@vger.kernel.org, pmladek@suse.com, mbenes@suse.cz,
	jikos@kernel.org, jpoimboe@kernel.org
Subject: Re:
Message-ID: <ZpWEifTpQ1vc1naA@redhat.com>
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240714195958.692313-1-raschupkin.ri@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Sun, Jul 14, 2024 at 09:59:32PM +0200, raschupkin.ri@gmail.com wrote:
> 
> [PATCH] livepatch: support of modifying refcount_t without underflow after unpatch
> 
> CVE fixes sometimes add refcount_inc/dec() pairs to the code with existing refcount_t.
> Two problems arise when applying live-patch in this case:
> 1) After refcount_t is being inc() during system is live-patched, after unpatch the counter value will not be valid, as corresponing dec() would never be called.
> 2) Underflows are possible in runtime in case dec() is called before corresponding inc() in the live-patched code.
> 
> Proposed kprefcount_t functions are using following approach to solve these two problems:
> 1) In addition to original refcount_t, temporary refcount_t is allocated, and after unpatch it is just removed. This way system is safe with correct refcounting while patch is applied, and no underflow would happend after unpatch.
> 2) For inc/dec() added by live-patch code, one bit in reference-holder structure is used (unsigned char *ref_holder, kprefholder_flag). In case dec() is called first, it is just ignored as ref_holder bit would still not be initialized.
> 
> 
> API is defined include/linux/livepatch_refcount.h:
> 
> typedef struct kprefcount_struct {
> 	refcount_t *refcount;
> 	refcount_t kprefcount;
> 	spinlock_t lock;
> } kprefcount_t;
> 
> kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags);
> void kprefcount_free(kprefcount_t *kp_ref);
> int kprefcount_read(kprefcount_t *kp_ref);
> void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
> void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
> bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
> 

Hi Roman,

Can you point to a specific upstream commit that this API facilitated a
livepatch conversion?  That would make a good addition to the
Documentation/livepatch/ side of a potential v2.

But first, let me see if I understand the problem correctly.  Let's say
points A and A' below represent the original kernel code reference
get/put pairing in task execution flow.  A livepatch adds a new get/put
pair, B and B' in the middle like so:

  ---  execution flow  --->
  -- A  B       B'  A'  -->

There are potential issues if the livepatch is (de)activated
mid-sequence, between the new pairings:

  problem 1:
  -- A      .   B'  A'  -->                   'B, but no B =  extra put!
            ^ livepatch is activated here

  problem 2:
  -- A  B   .       A'  -->                   B, but no B' =  extra get!
            ^ livepatch is deactivated here


The first thing that comes to mind is that this might be solved using
the existing shadow variable API.  When the livepatch takes the new
reference (B), it could create a new <struct, NEW_REF> shadow variable
instance.  The livepatch code to return the reference (B') would then
check on the shadow variable existence before doing so.  This would
solve problem 1.

The second problem is a little trickier.  Perhaps the shadow variable
approach still works as long as a pre-unpatch hook* were to iterate
through all the <*, NEW_REF> shadow variable instances and returned
their reference before freeing the shadow variable and declaring the
livepatch inactive.  I believe that would align the reference counts
with original kernel code expectations.

* note this approach probably requires atomic-replace livepatches, so
  only a single pre-unpatch hook is ever executed.


Also, the proposed patchset looks like it creates a parallel reference
counting structure... does this mean that the livepatch will need to
update *all* reference counting calls for the API to work (so points A,
B, B', and A' in my ascii-art above)?  This question loops back to my
first point about a real-world example that can be added to
Documentation/livepatch/, much like the ones found in the
shadow-vars.rst file.

Thanks,

--
Joe


