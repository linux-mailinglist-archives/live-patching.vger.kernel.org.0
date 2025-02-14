Return-Path: <live-patching+bounces-1198-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 583C7A360BA
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 15:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CBDE1894F2C
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 14:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46120266590;
	Fri, 14 Feb 2025 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AMhSVpqK"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0C8266EE7
	for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739544256; cv=none; b=AvWT6BaV94JoBvj10R3aa/FizaZE6NaMUKtcDfknWU7ZYy935nCmGn53ZEeXIk6i6WjtAY6jaTR9SRZSwXLLEOOTXxb0qzJJvUY1GEzCipcPGjVs8DpsmSXjrwxt66PjsSFATAY9Q7Z7W6+iIgSwWMOCP/zyMU2sRIi5heXF/I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739544256; c=relaxed/simple;
	bh=QZgp11yHjWSURR23Z6+mYbF4dlTwpSkZfMboEgwUGUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeSI/qNUmgBGK6ScyhGtB6XQBW01blcT1jxwyH/PJov7ttwvgN73sGP5ouBECQoYl4qbIuod1W1AAkD1S2EeCU9DqHk52jjYd+WdPA7V7cTh+k+++6PtuSVYGHMuXsB+hElJ1+LvaRBBUHMzLXJvA4O80gX5Dze17+w7/e6gGGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AMhSVpqK; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so3816531a12.1
        for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 06:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739544252; x=1740149052; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KgXBl6kfQe4WoakWk7TmVbhQT6wDBguGYyLw1VkJ2G8=;
        b=AMhSVpqKoFIiLycNTOaBl9pSWqSovV/buRRccp4bbhwygbBtyqNV4ocePstr1UpwcD
         9o3iUS2tWkTfJO6MxkX6yhsoNmCf4tMnHwHG6Xwzv/vnNumoIKoTUl+YBeGRuloUbX8a
         +qSbUcIiEsav9UFp5VjONIjEAyy12pIPSls2+SETWg6Lt9XqDAWQBtf3DpWB87RiaAfG
         EdHjwonyWCiFZ5qb6AJggmWBFeS5ri759S6RH0Of+8/+DvZtedp8ft/RpXvCqSzCTJCU
         qPsxjYRAY0Qg8mF1tpW6Yyv2+9K3MRC9nBcgg+G7Mkf15KzOhPB/hXuJeArBma8iyOnI
         Iq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739544252; x=1740149052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgXBl6kfQe4WoakWk7TmVbhQT6wDBguGYyLw1VkJ2G8=;
        b=rtyzadiaIQgRbHOwocHR8L3cr18ZfvcTFut889s7Tsy8jjoSQIq/Z+b8Tp5fsMyadq
         Rj8bH0u4Sd2lOpVurjxevvNcO5o17adgwUFbrY4gZmeB1o0BVwJcjBCiW6xocpS9eFzq
         Tp14egK5RTFJyqO8GSMDrYqBjour33HKgA+vH79X4BJEaXaa7vkMvFJqKH+80BW7R6F2
         sR4JzPcL50v//lEduqAObg4Y2Ee740URBuQFYhyzuExUlW3K/OQGIW9vh/L7uBfbZox/
         QxBxlNCgbGKaslKRyOit/vmIy7XX821wZAncLVyLwJiywQwYo6vJktnWu+w5RgMowZeJ
         Ib5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXihYsDq+Nt5tFQzuLVDt7UmD7vRp6K7PTgeJu/H8/G4/muZybAn0xMNX+WyAnVWPZKorvgmycGHuWRqeqc@vger.kernel.org
X-Gm-Message-State: AOJu0YzXc3bNYsy3mfZ7gHrz7D10LgO65Mlvv9oZgTCh8OwD5L9ui9CT
	fO5/cTF3wiGs2HMjOrn31VGcoCLpUX3fR7EkZX4+ZFSwWgCqBenZJBZzC9ZkmZI=
X-Gm-Gg: ASbGncuc1wofh94bV8OoJqB88gO5cqR8kMDjKR4iYCN/jS2ltCxZd2q7iqIsWQV82Bx
	6wFkq0YWE826SpueavZKAXRBH8O21hR0Ujbp6AjT/NbVF+PTzdRJ8GfUNHSZ4GZABFPUkYKmbSA
	OrkTXvry6X8IYq8YBt+rjcvwb2N9wUpESg+tjqitANC9OF8nkh34gKro7VTfRLEsQd52Hpfeiw7
	v9WgQdmZapD94Fll+GTwca90kmAEf5kNIpwNctZRwGF+BkqnIOH3z6wXK6ntnJ9ll9JUWZob714
	BreZWP1w0gvh3RKMng==
X-Google-Smtp-Source: AGHT+IGtaR2Lw7gIuJ6kRCKcLuFlDHl6GHCZSvkTrV0nNKx9yaTa5AuZOsws3UiVDj0dhY9qcsdevw==
X-Received: by 2002:a05:6402:2788:b0:5db:f26d:fff8 with SMTP id 4fb4d7f45d1cf-5dec9ffa08emr6475629a12.22.1739544252116;
        Fri, 14 Feb 2025 06:44:12 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece270a7fsm3025761a12.58.2025.02.14.06.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 06:44:11 -0800 (PST)
Date: Fri, 14 Feb 2025 15:44:10 +0100
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <Z69Wuhve2vnsrtp_@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz>
 <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
 <Z62_6wDP894cAttk@pathway.suse.cz>
 <20250213173253.ovivhuq2c5rmvkhj@jpoimboe>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213173253.ovivhuq2c5rmvkhj@jpoimboe>

On Thu 2025-02-13 09:32:53, Josh Poimboeuf wrote:
> On Thu, Feb 13, 2025 at 10:48:27AM +0100, Petr Mladek wrote:
> > On Wed 2025-02-12 17:36:03, Josh Poimboeuf wrote:
> > > Or, we could do something completely different.  There's no need for
> > > klp_copy_process() to copy the parent's state: a newly forked task can
> > > be patched immediately because it has no stack.
> > 
> > Is this true, please?
> > 
> > If I get it correctly then copy_process() is used also by fork(2) where
> > the child continues from fork(2) call. I can't find it in the code
> > but I suppose that the child should use a copy of the parent's stack
> > in this case.
> 
> The child's *user* stack is a copy, but the kernel stack is empty.
> 
> On x86, before adding it to the task list, copy->process() ->
> copy_thread() sets the child's kernel stack pointer to empty (pointing
> to 'struct inactive_task_frame' adjacent to user pt_regs) and sets the
> saved instruction pointer (frame->ret_addr) to 'ret_from_fork_asm'.
> 
> Then later when the child first gets scheduled, __switch_to_asm()
> switches to the new stack and pops most of the inactive_task_frame,
> except for the 'ret_from_fork_asm' return value which remains on the top
> of the stack.  Then it jumps to __switch_to() which then "returns" to
> ret_from_fork_asm().

Right. Only the *user* stack is a copy.

I guess that we really could consider the new task as migrated
and clear TIF_PATCH_PENDING.

But we can't set child->patch_state to KLP_TRANSITION_IDLE. It won't
work when the transition gets reverted. [*]

Best Regards,
Petr

[*] I gave this few brain cycles but I did not find any elegant
    way how to set this a safe way and allow using rcu_read_lock()
    in klp_try_complete_transition().

    It might be because it is Friday evening and I am leaving for
    a trip tomorrow. Also I not motivated enough to think about it
    because Yafang saw the RCU stall even with that rcu_read_lock().
    So I send this just for record.

