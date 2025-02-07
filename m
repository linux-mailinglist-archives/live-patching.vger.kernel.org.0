Return-Path: <live-patching+bounces-1126-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADB1A2B992
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 04:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 907451660B3
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 03:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46ED15B99E;
	Fri,  7 Feb 2025 03:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaZGx/y8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408AF14658B;
	Fri,  7 Feb 2025 03:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738898243; cv=none; b=O8CESrz78gypTB6p9PCLsst1xNA4mQEQFY/Wme3gYx9GKobKKJHPGM4wXQiZT9XAodqWZW7Bb5T/yek5Hd6SgeqRuGcxn/a+k+fc5Od9Q+SnX/39IDKjdqVfs06FfQXYpWftUiLwROqWUeiBlsEx8GiXmc/lISm0CZM8kIqbl60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738898243; c=relaxed/simple;
	bh=SQveBs6I9QKwgjiPxa7XSzW6e/qfj0nmClmDPqbpSwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ktv+oJJJ3l7bIrgKPTuX4mq79KhAUl0Kk9CcvLBI6RcxFsU+f1LjFLG+cer6BCJhMLG5gBaq79KPTBq3sYHTlchbMaPBfkOgB+70kzQs5p47TQgTISgZP9pPgN1gx6jiq7UN5GhdQh6QWX6s7sqtEWOpx25tqKWpUhINAg/h51Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eaZGx/y8; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6dcdf23b4edso14052006d6.0;
        Thu, 06 Feb 2025 19:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738898241; x=1739503041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZlbDcy36pPkHq/elg7hFev/RYK+Oqb1WkHxloEn7vk=;
        b=eaZGx/y8cgDNHx+9ZmCOPmjjaaOaXOtM68U/TAMgaL6jpgybmcQxUSY3/vM8+vTHEW
         PHmm8aB7BfZEFrY9shDpYYITcbHYJfYfAN3g1BWM30xnc4SyI8kUmh5AIcp2WJ0SYaEM
         7swJKo/f8RcjuWiAgDwtF0h4Kh/npZTAynAeU4Q7jkXRN4DDdVZZbeDMgtGa594AJs54
         Baw+t2nFMfxsYBFMQkarA5RjH7HHQ1pmYNlCKpkr/GgKoQd5yoRu4aOl8RIpmDB5zL5e
         8Ai3AufeCoe5+qtTzQ+dOF4phCRt4z20KifstOGN8LtN6l14iO6LXx0a9qoNi2CCWu/z
         1LDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738898241; x=1739503041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZlbDcy36pPkHq/elg7hFev/RYK+Oqb1WkHxloEn7vk=;
        b=DYrJ44GAfVTh630TkZoAVdyqfmnUeHJqNxV1u4RsdRmfTfn4w0obf8IihHanf9oG5H
         I6tqwRdI0IQi2oxd1XL5IsU5QjBw6tGJaZ0hQEb/ZddVEhPAHuoIFmlPaOE89MRiDdh/
         MxnK4sLgyyH6KCUOLRG8SbSIp6KYS/xLo4z4ZPsyF6plo9O6dRkxj24ZA4v1BDP+kGQf
         w/raGe0UBiBUbGo4qZxB7ZLP2VYVo3Xy74s3vVQ5EFUBE4+tWp2+oLiRT6qo5djNKoVk
         s2y1Qt+oGzAgFvR820uMfho+ePp7ziXUngBqlcoiyNuKZv0HE4i+hoqsrrbPIV0cscYF
         XvVA==
X-Forwarded-Encrypted: i=1; AJvYcCUt7fws2r1SvaTYeUQOolO8h8lLnjoToDbCqoXOtw5immJGorjuFgn6TxAH4qk/Y3L1VoeXjUKeafFTQTc=@vger.kernel.org, AJvYcCW77ONfTg3GDrNu4PiMU8oO4ByfRgzZbQwmvSunlbE0doHvpeAQWM6Hr+Ke2pMRCkzopcdxTsWe7FMpivHgUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRAn9Va0rsNRsc1hMiLdAT3etqH3ZMKCJXWfKlO3YPxKsMve8z
	yDABu5qsyQ8HVDhESlnYDRkrG1eI1BU5c2O1IA99LVMtyiNyYjg7CItV+PsotrvenMbohkIm54K
	N5mMStMCPrYeop/Un7DQ93XAeKYs=
X-Gm-Gg: ASbGncuXxJPfkPFmg028EFQbwTZzAx8BK4+pnFS0lkL93LXSEKAFNkeOCVQsTmEGjGA
	+IDmZCjPPpmcL04fsUoJdylg82dWt8jG5eU9NYrddUg18bsOVTK8UV0Aes28XXTjPsgNsmFkhcR
	Q=
X-Google-Smtp-Source: AGHT+IHtIKEcTjSTQlWh5lwk9JOYeBQcpTOQQVX2RILLZ4vFU4GB2dTZQSCTgiGNSqAUrpgbdSCaWgTp03coCg6W+Zw=
X-Received: by 2002:ad4:5f89:0:b0:6e4:3c52:d671 with SMTP id
 6a1803df08f44-6e4455eda4cmr19801736d6.14.1738898241017; Thu, 06 Feb 2025
 19:17:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe>
In-Reply-To: <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 7 Feb 2025 11:16:45 +0800
X-Gm-Features: AWEUYZkBHU9QVMsn_rdgqikVxkvOfZf_63qXyhUzG8DpNgBaUUy5VdNNCvU6V2Q
Message-ID: <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 10:31=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Mon, Jan 27, 2025 at 02:35:26PM +0800, Yafang Shao wrote:
> > The atomic replace livepatch mechanism was introduced to handle scenari=
os
> > where we want to unload a specific livepatch without unloading others.
> > However, its current implementation has significant shortcomings, makin=
g
> > it less than ideal in practice. Below are the key downsides:
> >
> > - It is expensive
> >
> >   During testing with frequent replacements of an old livepatch, random=
 RCU
> >   warnings were observed:
> >
> >   [19578271.779605] rcu_tasks_wait_gp: rcu_tasks grace period 642409 is=
 10024 jiffies old.
> >   [19578390.073790] rcu_tasks_wait_gp: rcu_tasks grace period 642417 is=
 10185 jiffies old.
> >   [19578423.034065] rcu_tasks_wait_gp: rcu_tasks grace period 642421 is=
 10150 jiffies old.
> >   [19578564.144591] rcu_tasks_wait_gp: rcu_tasks grace period 642449 is=
 10174 jiffies old.
> >   [19578601.064614] rcu_tasks_wait_gp: rcu_tasks grace period 642453 is=
 10168 jiffies old.
> >   [19578663.920123] rcu_tasks_wait_gp: rcu_tasks grace period 642469 is=
 10167 jiffies old.
> >   [19578872.990496] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is=
 10215 jiffies old.
> >   [19578903.190292] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is=
 40415 jiffies old.
> >   [19579017.965500] rcu_tasks_wait_gp: rcu_tasks grace period 642577 is=
 10174 jiffies old.
> >   [19579033.981425] rcu_tasks_wait_gp: rcu_tasks grace period 642581 is=
 10143 jiffies old.
> >   [19579153.092599] rcu_tasks_wait_gp: rcu_tasks grace period 642625 is=
 10188 jiffies old.
> >
> >   This indicates that atomic replacement can cause performance issues,
> >   particularly with RCU synchronization under frequent use.
>
> Why does this happen?

It occurs during the KLP transition. It seems like the KLP transition
is taking too long.

[20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
[20329703.340417] livepatch: 'livepatch_61_release6': starting
patching transition
[20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 is
10166 jiffies old.
[20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 is
10219 jiffies old.
[20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 is
10199 jiffies old.
[20329754.848036] livepatch: 'livepatch_61_release6': patching complete

>
> > - Potential Risks During Replacement
> >
> >   One known issue involves replacing livepatched versions of critical
> >   functions such as do_exit(). During the replacement process, a panic
> >   might occur, as highlighted in [0]. Other potential risks may also ar=
ise
> >   due to inconsistencies or race conditions during transitions.
>
> That needs to be fixed.
>
> > - Temporary Loss of Patching
> >
> >   During the replacement process, the old patch is set to a NOP (no-ope=
ration)
> >   before the new patch is fully applied. This creates a window where th=
e
> >   function temporarily reverts to its original, unpatched state. If the=
 old
> >   patch fixed a critical issue (e.g., one that prevented a system panic=
), the
> >   system could become vulnerable to that issue during the transition.
>
> Are you saying that atomic replace is not atomic?  If so, this sounds
> like another bug.

From my understanding, there=E2=80=99s a window where the original function=
 is
not patched.

klp_enable_patch
+ klp_init_patch
   + if (patch->replace)
          klp_add_nops(patch);  <<<< set all old patches to nop

+ __klp_enable_patch
   + klp_patch_object
      + klp_patch_func
         + ops =3D klp_find_ops(func->old_func);
            + if (ops)
                   // add the new patch to the func_stack list
                   list_add_rcu(&func->stack_node, &ops->func_stack);


klp_ftrace_handler
+ func =3D list_first_or_null_rcu(&ops->func_stack, struct klp_func
+ if (func->nop)
       goto unlock;
+ ftrace_regs_set_instruction_pointer(fregs, (unsigned long)func->new_func)=
;

Before the new atomic replace patch is added to the func_stack list,
the old patch is already set to nop. If klp_ftrace_handler() is
triggered at this point, it will effectively do nothing=E2=80=94in other
words, it will execute the original function.
I might be wrong.

--
Regards
Yafang

