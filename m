Return-Path: <live-patching+bounces-1177-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 693CFA33B9E
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 10:50:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 244DF3A93B2
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 09:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1CC20F089;
	Thu, 13 Feb 2025 09:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PnktyGiL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD7620F072
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 09:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739440113; cv=none; b=EhdHPM2eXOcBqbzrKy1agr6q6vZfSHbcaLjQ3Njq7QSe4iryL9V/oDGG+mv7TLc4VKwnJ609Rq/tK04ATjiAnc0vaLHoWvdu3dOKfDspOk4JJQtkbJiqI4ddLcbp7UzsE3TvWgskx93AYrSQ9m3dq0Td/YekBwv4y5MgAG42lhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739440113; c=relaxed/simple;
	bh=Tpbbj17hHKpKjaoH+Xe3DrKYmvgaigBmtPM3trb5ypw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3PFiHUFN9ThYXx3bpu984FSCWJI7vl7/v43TGrcGWq4cVgReR0OANbAcTM69qbywgdJPNP9ZX4EFWblnI541b9VIZFdzZSMiLPZ180jAxJhrX5qUAs4IV8CjdRveIAoVR+FLzd6AKoYZMu2o0BmzUw/8MsCugdZ/9ZYK/xcZ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PnktyGiL; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab7d3bcf1ceso114736266b.3
        for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 01:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739440110; x=1740044910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cYI3Rq9HhGXVUyZFyKZyEC42yAKd8ENsLiS8uoR/KUE=;
        b=PnktyGiL5I05oOaTYTu70CDxWx0RXx1Jk/2PmYoPoKC03XSqOzK3CsIRPyU8KIiyuk
         0uLhoT1A9NYiRs4O3Y+9naZJhuS1xudA766MHSTeDHvHAkJOckMWa1AjiT/d9cwtcHB5
         V1Zn4HliI9dGUggQ1jubaWNPOHKaUOkNOYVpDwzFxxVCJ4jxAbvqMArCdWU/JYa3ovtS
         aAyDYg/6PwVyJNe0FKEymvbUIf24kMK5T6SzuD1Kx+eAGegB/hg0CRR2P5zbIAGRbzW3
         f/y8FV6465BHTg5hmV67XSJfTuiOydGBVwVqlyjNO/LYHFg46YcOQFGNH85oqG2ZhabT
         1XDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739440110; x=1740044910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYI3Rq9HhGXVUyZFyKZyEC42yAKd8ENsLiS8uoR/KUE=;
        b=ox9lU5JeoDo+nM+2IBFMLW4smzxSYXP6/zk9JHNw60CdBX8CinR0mtJXJJ7c7jxlnA
         Abd8jpqND3OMzvIbns6jLCJGxv+jYZEqjwxt8UC1R1xMX/ff2kiqOGII0FP16ik1irJB
         LPteKNtQn2BCx4iBw0FIsorv2IUZw2Bq1J9cTElurSNZioBuxHNzkn3ZZsO3443gO+LI
         2wr42MuYrX0FrCUDAgaz1/APKuZ/TUBSOIrV97904KdL/f2/GP9EGpTMCbSc7uoFqyoG
         sm0gplHZ6TlOiUBOo9dRGtvWEz+K0/om7074m0xxow+XWckhOQx6NisTjjZrrmcoZ0Zt
         fvwA==
X-Forwarded-Encrypted: i=1; AJvYcCVtNMfxCWNKoZZnoPPLt1Mgq/i9WKmSMY227KqJtfyB2h05inODpnSIh+0IrK4fI9wxHral0Yn5Op8bQog1@vger.kernel.org
X-Gm-Message-State: AOJu0YyxS0HA40ngRWI14k+cXjjVrDbc3GgT2geiF6PQXOGbecUqGeMv
	C4GBX2qcpinRdAtqgQmQhM3lbfavpqnA3/Fc0ZEnOu98XBa8NbkodCo37pCH2Pg=
X-Gm-Gg: ASbGncuw4m/7he2MMPC24+FQMkEoHBrWvBd7J2tF1nZL+wtJv+UlymHF4GStZsYfgnW
	GdmCjbsEDXHQiqA5DT/3id2Rxjt7Zb7jTVoJhkGgNwem/Gr70W+MkIXHARbW+lH0dLAzsUqW35r
	V62colI71acDfvSuYgHImA9gSNv1UjMiJTOF/CLQTyPl5s8qrNeLj+jKWwWQOkBtYwNl0bVM+fW
	X+6VbOTYhpc47tOUY9cs2kMNNLsbeaBTB1V1T8DcTaoM+4w5CWejqUVXH6LOmyEJ32rpuGHEXT1
	bqkE23Vf2582HspWlA==
X-Google-Smtp-Source: AGHT+IHwa1dRgjFxIUzhrtChqbYh9WUsXdlsl4VfdTuJhuGVM2bL1oKm9to6u2X2PgmIR74uRNZZRw==
X-Received: by 2002:a17:907:6d29:b0:ab7:a4b1:99f with SMTP id a640c23a62f3a-ab7f3783e8cmr611861466b.30.1739440108905;
        Thu, 13 Feb 2025 01:48:28 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba5339cdedsm95888366b.142.2025.02.13.01.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 01:48:28 -0800 (PST)
Date: Thu, 13 Feb 2025 10:48:27 +0100
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <Z62_6wDP894cAttk@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz>
 <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>

On Wed 2025-02-12 17:36:03, Josh Poimboeuf wrote:
> On Wed, Feb 12, 2025 at 04:42:39PM +0100, Petr Mladek wrote:
> > CPU1				CPU1
> > 
> > 				klp_try_complete_transition()
> > 
> > 
> > taskA:	
> >  + fork()
> >    + klp_copy_process()
> >       child->patch_state = KLP_PATCH_UNPATCHED
> > 
> > 				  klp_try_switch_task(taskA)
> > 				    // safe
> > 
> > 				child->patch_state = KLP_PATCH_PATCHED
> > 
> > 				all processes patched
> > 
> > 				klp_finish_transition()
> > 
> > 
> > 	list_add_tail_rcu(&p->thread_node,
> > 			  &p->signal->thread_head);
> > 
> > 
> > BANG: The forked task has KLP_PATCH_UNPATCHED so that
> >       klp_ftrace_handler() will redirect it to the old code.
> > 
> >       But CPU1 thinks that all tasks are migrated and is going
> >       to finish the transition
> 
> 
> Maybe klp_try_complete_transition() could iterate the tasks in two
> passes?  The first pass would use rcu_read_lock().  Then if all tasks
> appear to be patched, try again with tasklist_lock.
> 
> Or, we could do something completely different.  There's no need for
> klp_copy_process() to copy the parent's state: a newly forked task can
> be patched immediately because it has no stack.

Is this true, please?

If I get it correctly then copy_process() is used also by fork(2) where
the child continues from fork(2) call. I can't find it in the code
but I suppose that the child should use a copy of the parent's stack
in this case.

Or am I wrong?

Best Regards,
Petr

