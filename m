Return-Path: <live-patching+bounces-503-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F63954E60
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2024 18:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8DDC1F25A65
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2024 16:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6271BE84B;
	Fri, 16 Aug 2024 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KZ5BjdJY"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F971BDA84
	for <live-patching@vger.kernel.org>; Fri, 16 Aug 2024 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723824169; cv=none; b=fQ2bKslQYO52G0BsWJFrkMVzvIJe9/FLeTG/Dos35eWQ7+OgR6b6Sq0IZctLZhH/zXEi15O3PwYV+4IbYIU7Hjq5lGt0Z6LD18UuKDM5lXpkUXgznPOvtSo4r4fpHXMENL0SCH3b1uUXRRQngl5sbo5laKBNeKo/Qx5cyqdurd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723824169; c=relaxed/simple;
	bh=L8Gio1lKEf6ScjWD+hvMyeDe/0qL5kpCnp2TfQU8btU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnU+D9ygNVGm89qXGSGzx4H+JBcnqjS0yapXR3viU1ViNrVNaPoJ3qlUHKFsbprXu6PSrg5v8pv5f0iEQKyt2r+HVKQjZhq/DYlxyxaNLOc8ETk3X7L+0H4tq7jhfQqoiYPggrarGCWPW1ka9YktpO5jDjUwg6aiu/gGzTQYd2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KZ5BjdJY; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7d2a9a23d9so260391066b.3
        for <live-patching@vger.kernel.org>; Fri, 16 Aug 2024 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723824165; x=1724428965; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+59+r4nVPaGYn60uFGeWEcerq53321A8XpZYq36YoFE=;
        b=KZ5BjdJYy3+q4S8v21Ahy4AptDT2oZ0FluDT8BJ/1vSWP2OAvh2jqDG0Un5J9veUPe
         jGJOMLxQGbs/aYDH2LXkEdHc8AcxCcomFU4LJzz1//R+Z8xvC9HSCwSMDTqpN2X8JRqp
         0bTkwZC/zHb5awUMRR4DOE2VAlfnDYo6cHFfHyREmnp+ZZi9UejBoYWqSDqbIj3uYSF+
         e5IFb8l6AzbE82NQ6VF2mNoVZgjFGmA76TEMWWdKeRJG+1ITR3XnnTuBQQ72TTDoBG4a
         ilEbCzl65aIKLPQQJm8Vk4bq79FsrFuX7BWFzCO5kEgnqhRcguWQpCxXNzvGcR7s5E6O
         kXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723824165; x=1724428965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+59+r4nVPaGYn60uFGeWEcerq53321A8XpZYq36YoFE=;
        b=bpnyO3qIMFgLuoh274vpHpzG2m42MoDUcb9dO9dthRfI0q8E8f2gMp4ge4MGJKRJrO
         d5HJojnyMT1BfATY849H4jUwffeaHCxnGjnHxO+O9q+mbusiWyLo37rsnG9xHl2o2cIb
         zyd3XwVj3svn12PJRSl99utlWB38L+gSLwM68DSqZ1XVdQvXhFLba9ATjBPyzOL6jkas
         lc2iRO96Gg9R/wqXbiiS++HQS91awNWSiMkRnwR+IY071UHOtX+d854JNfllVXUiBDeo
         m7Rcd4F+htjxGwc7Wtml8FZ1FX4AwidJSk9JepxTZN7wJclxgcU/tP08ZKGYe5fXzTb5
         Xz2w==
X-Forwarded-Encrypted: i=1; AJvYcCWgBtBOOCV03LNEe3ZbUN/6rJH74vW+aNmX4Hr9oxuADeNmXti9JIbQVQEiAfzi9njD0SSRJ8bMR1i/imnKr7B3fpQ1LVlp5BoeHkmd6w==
X-Gm-Message-State: AOJu0YwM2Vd3EoZlEykjXfHOl40XOOdQUX3UPkaVt+vHNQFSW76FrBkF
	vLttObKp8nf53lti9TyPJ5q488MbjpmRS4PTuWWM25n0DLLA7I1E07VsETWVSec=
X-Google-Smtp-Source: AGHT+IG6GfcQCc6qS1Tf6UMdMwBMR1h8V/kjKhBjDxeM3vw9QJvQ8VaMgJdw6yG0tZp3rI37wfsQJQ==
X-Received: by 2002:a17:907:e6e2:b0:a7d:a25b:31be with SMTP id a640c23a62f3a-a839295925fmr243898966b.39.1723824164697;
        Fri, 16 Aug 2024 09:02:44 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838d00f0sm272387466b.87.2024.08.16.09.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 09:02:44 -0700 (PDT)
Date: Fri, 16 Aug 2024 18:02:42 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [POC 3/7] livepatch: Use per-state callbacks in state API tests
Message-ID: <Zr94Iu7_wSdLgz9S@pathway.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com>
 <20231110170428.6664-4-pmladek@suse.com>
 <alpine.LSU.2.21.2407251343160.21729@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2407251343160.21729@pobox.suse.cz>

On Thu 2024-07-25 13:48:06, Miroslav Benes wrote:
> Hi,
> 
> On Fri, 10 Nov 2023, Petr Mladek wrote:
> 
> > Recent changes in the livepatch core have allowed to connect states,
> > shadow variables, and callbacks. Use these new features in
> > the state tests.
> > 
> > Use the shadow variable API to store the original loglevel. It is
> > better suited for this purpose than directly accessing the .data
> > pointer in state klp_state.
> > 
> > Another big advantage is that the shadow variable is preserved
> > when the current patch is replaced by a new version. As a result,
> > there is not need to copy the pointer.
> > 
> > Finally, the lifetime of the shadow variable is connected with
> > the lifetime of the state. It is freed automatically when
> > it is not longer supported.
> > 
> > This results into the following changes in the code:
> > 
> >   + Rename CONSOLE_LOGLEVEL_STATE -> CONSOLE_LOGLEVEL_FIX_ID
> >     because it will be used also the for shadow variable
> > 
> >   + Remove the extra code for module coming and going states
> >     because the new callback are per-state.
> > 
> >   + Remove callbacks needed to transfer the pointer between
> >     states.
> > 
> >   + Keep the versioning of the state to prevent downgrade.
> >     The problem is artificial because no callbacks are
> >     needed to transfer or free the shadow variable anymore.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> 
> it is much cleaner now.
> 
> [...]
> 
> >  static int allocate_loglevel_state(void)
> >  {
> > -	struct klp_state *loglevel_state;
> > +	int *shadow_console_loglevel;
> >  
> > -	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
> > -	if (!loglevel_state)
> > -		return -EINVAL;
> > +	/* Make sure that the shadow variable does not exist yet. */
> > +	shadow_console_loglevel =
> > +		klp_shadow_alloc(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID,
> > +				 sizeof(*shadow_console_loglevel), GFP_KERNEL,
> > +				 NULL, NULL);
> >  
> > -	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
> > -	if (!loglevel_state->data)
> > +	if (!shadow_console_loglevel) {
> > +		pr_err("%s: failed to allocated shadow variable for storing original loglevel\n",
> > +		       __func__);
> >  		return -ENOMEM;
> > +	}
> >  
> >  	pr_info("%s: allocating space to store console_loglevel\n",
> >  		__func__);
> > +
> >  	return 0;
> >  }
> 
> Would it make sense to set is_shadow to 1 here? I mean you would pass
> klp_state down to allocate_loglevel_state() from setup callback and set
> its is_shadow member here. Because then...

Right.

> >  static void free_loglevel_state(void)
> >  {
> > -	struct klp_state *loglevel_state;
> > +	int *shadow_console_loglevel;
> >  
> > -	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
> > -	if (!loglevel_state)
> > +	shadow_console_loglevel =
> > +		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
> > +	if (!shadow_console_loglevel)
> >  		return;
> >  
> >  	pr_info("%s: freeing space for the stored console_loglevel\n",
> >  		__func__);
> > -	kfree(loglevel_state->data);
> > +	klp_shadow_free(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID, NULL);
> >  }
> 
> would not be needed. And release callback neither.
> 
> Or am I wrong?

No, you are perfectly right.

> We can even have both ways implemented to demonstrate different 
> approaches...

I have implemented only your approach ;-)

That said, I am going to keep the callback so that the selftest could
check that it is called at the right time. But the callback will
only print the message. And a comment would explain that is not
really needed.

Also I am going to add a .state_dtor callback so that we could test
the shadow variable is freed. The callback will only print a message.
It is a simple shadow variable and the memory is freed automatically
together with the struct klp_shadow.

Best Regards,
Petr

