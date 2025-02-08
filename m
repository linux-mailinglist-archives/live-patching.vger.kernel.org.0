Return-Path: <live-patching+bounces-1138-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F33A2D388
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 04:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B317C188DE2C
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 03:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0569615575C;
	Sat,  8 Feb 2025 03:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYZhI65H"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1D42913;
	Sat,  8 Feb 2025 03:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738985967; cv=none; b=Q9f4wgSW1E/u4N8+m+b3dKJ8W23Tu7wr2u+wgACHe7zGWENrSKtJzNVGSIC3A77uQvo+Vn6rtzXkOQ9y+4ZcdoQ4R4gBhyHmjzkEVfjWnf5wlpw2He1QoYNolrMptWpIK/9isKhyfM2gvmcH6kwpWWv/HlAP79c2ZHC2VJRyN6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738985967; c=relaxed/simple;
	bh=S7xEkQTFAxZyROm5WJD7bnemp5XjOPQlcNrOpuT7x0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XmtsJ19dgCY3v6n8R/zw1i0ql5lZlrHYmR61P2Fm0yyLYQrFRkxmtvoakjQwpoK4kparH1FCeUM7Gfuk6LUpPdwfMfACrZg3dQ3O9X21bq1Ftt+Hwqvg5J8+9+PgEOQi0QdGRD/P8tWkVL95YHlufBwJ/0kSSQsrxP5AZpqIG7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYZhI65H; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e45258610bso1790656d6.1;
        Fri, 07 Feb 2025 19:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738985965; x=1739590765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4X0b2ly0rmodwkPqsS7FaEUdxg4bMY4i1mzslLuCMXo=;
        b=fYZhI65HBIzJ8ZGKr/5Wm1RsAcsP8/yNBaFgYdlSoZrPh7ZeUJjXcdpmJs+eqabWbu
         SpN176In14txc50YT+bzHKNL2Lvil88RePITIa6BsvvCJXE9xveACHxPzR/QYDE9ZsmL
         3yfglwZ4JStoPs6ZHvMzVYn+PFtkEGwrEFcs7b2y9N2Yj+fhJCD4qds9PmnKbH9cOCuO
         NS10XB/D29MaXQNM4sWJ/Z9iJwkk7O/ukZGRaqwThkZ7WIG9UB/XTzrIHwlOxckpJY+f
         6rbvSHymTGpuFn6fcNUBiM4a5CK6O5EzEL5PjRLCSDpay36yLLMBVtV1vYvcyYnQZcik
         Ms8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738985965; x=1739590765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4X0b2ly0rmodwkPqsS7FaEUdxg4bMY4i1mzslLuCMXo=;
        b=qZ2eHibe1MqxCgekOqeMPaWDOKStqwJ6lXEX7CddYKaRdWAve3coBOS/QNJP+unj7O
         6vMACet2elsL1BbI2HgtGC9d5QnXjUhAcx9Rd2wDog7ePwHXdcql/loujiScJaK4iZY8
         ctw/U+aB2ZogjC7jXpEVSXOPwt5YxS2YieLYzaL3j33Phe+VUKzcoJ23z6+cJCmO9s84
         0XSISA8pvtCr1onQyenLEdKaIojI8fFJSvVJxjlBVJwyX4yJfpnTeEit6ZDYXjfQ0glf
         ig5wUFg440/BghmO6cZBpJ4ayQAwtVIbH206YXK7+Wl3/qkMqFop+RiNHNLU0bpdgYqe
         8MWw==
X-Forwarded-Encrypted: i=1; AJvYcCUlqx6KI/wknUdM9TBSeN8o4Ap4ZrKmouwB/HE567KALxFnugL+dlD4HN8kECCqXBb1/JMLazZLasw951A=@vger.kernel.org, AJvYcCWcmzv1n46p2II+7wQuaZYsX6B3A7gOL4Spi0IUa9VlBwzpJyDbmjh5EZxF8P4RAW+gV32x1yxa7mgDsiFOtw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1nZNkjVrqgz1fhX39/E3g0OlnThNcvysS7ENL4TLcodhma9E2
	N1ImTtu+b3yBV28BMgVxBOu5Y9iJKVdwcBrN6iIqYL9Wu57ny3Mi2zrbA6SUd1IaVTM0rCvOl1r
	aKQ0YYNunga3/uCaKV2tJKPPTSSQ=
X-Gm-Gg: ASbGnctu/MhSap3QLSkKtyKBwEYKRUm9U4mepvGumhrWRuFKyJzbFufgny9GWsDNkbV
	C/BG+eg8CThe153vU+t6KqOdJUSzSBin+AEgvxxfsnb5jpLHzsU4JgmTegGbJep1pCC0Gy3ydpQ
	w=
X-Google-Smtp-Source: AGHT+IGe6MgdmgNnTqWSP6Tg3Hty4CqAyQViOunCJ5kJTaqBohn/eRHW6OcA/d+eb4sVFpBAfML40OKZB9QppFDBolM=
X-Received: by 2002:a05:6214:ca2:b0:6e4:2e00:dda6 with SMTP id
 6a1803df08f44-6e439aa1fa6mr147358006d6.2.1738985965039; Fri, 07 Feb 2025
 19:39:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe> <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>
 <20250207165913.f4wp72k6g64tqgin@jpoimboe>
In-Reply-To: <20250207165913.f4wp72k6g64tqgin@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 8 Feb 2025 11:38:49 +0800
X-Gm-Features: AWEUYZn7ea3h7egR1gurxzOoukQveuzy0CSKDMINwS5HjGuIMeXFTY5z28NFvOA
Message-ID: <CALOAHbCSP_gSYTM_qyq4ak6YfDSw+5euEo_mkvadAfVJt9TNJg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 8, 2025 at 12:59=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Fri, Feb 07, 2025 at 11:16:45AM +0800, Yafang Shao wrote:
> > On Fri, Feb 7, 2025 at 10:31=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > > Why does this happen?
> >
> > It occurs during the KLP transition. It seems like the KLP transition
> > is taking too long.
> >
> > [20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
> > [20329703.340417] livepatch: 'livepatch_61_release6': starting
> > patching transition
> > [20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 is
> > 10166 jiffies old.
> > [20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 is
> > 10219 jiffies old.
> > [20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 is
> > 10199 jiffies old.
> > [20329754.848036] livepatch: 'livepatch_61_release6': patching complete
>
> How specifically does the KLP transition trigger rcu_tasks workings?

I believe the reason is the livepatch transition holds the spinlock
tasklist_lock too long. Though I haven't tried to prove it yet.

>
> > Before the new atomic replace patch is added to the func_stack list,
> > the old patch is already set to nop. If klp_ftrace_handler() is
> > triggered at this point, it will effectively do nothing=E2=80=94in othe=
r
> > words, it will execute the original function.
> > I might be wrong.
>
> That's not actually how it works.  klp_add_nops() probably needs some
> better comments.

With Petr's help, I now understand how it works.

What do you think about adding the following comments? These comments
are copied from Petr's reply [0].

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f2071a20e5f0..64a026af53e1 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -559,6 +559,9 @@ static int klp_add_object_nops(struct klp_patch *patch,
  * Add 'nop' functions which simply return to the caller to run
  * the original function. The 'nop' functions are added to a
  * patch to facilitate a 'replace' mode.
+ *
+ * The nop entries are added only for functions which are currently
+ * livepatched but they are no longer livepatched in the new livepatch.
  */
 static int klp_add_nops(struct klp_patch *patch)
 {


[0]. https://lore.kernel.org/live-patching/CALOAHbBs5sfAxSw4HA6KwjWbH3GmhkH=
Jqcni0d4iB7oVZ_3vjw@mail.gmail.com/T/#m96263bd4e0b2a781e5847aee4fe74f7a17ed=
186c

>
> It adds nops to the *new* patch so that all the functions in the old
> patch(es) get replaced, even those which don't have a corresponding
> function in the new patch.
>
> The justification for your patch seems to be "here are some bugs, this
> patch helps work around them", which isn't very convincing.

The statement "here are some bugs, the hybrid model can workaround
them" is correct. However, the most important part is "This selective
approach would reduce unnecessary transitions," which will be a
valuable improvement to the livepatch system.

In the old 4.19 kernel, we faced an issue where we had to unload an
already-loaded livepatch and replace it with a new one. Without atomic
replace, we had to first unload the old livepatch (along with others)
and then load the new one, which was less than ideal. In the 6.1
kernel, atomic replace is supported, and it works perfectly for that
situation. This is why we prefer using the atomic replace model over
the old one.

However, atomic replace is not entirely ideal, as it replaces all old
livepatches, even if they are not relevant to the new changes. In
reality, we should not replace livepatches unless they are relevant.
We only need to replace the ones that conflict with the new livepatch.
This is where the hybrid model excels, allowing us to achieve this
selective replacement.

> Instead we
> need to understand the original bugs and fix them.

Yes, we should continue working on fixing them.

--
Regards

Yafang

