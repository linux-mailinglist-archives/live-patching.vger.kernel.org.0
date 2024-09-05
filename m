Return-Path: <live-patching+bounces-610-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7598996DBE6
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 16:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 005D41F2843D
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 14:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319F6168B8;
	Thu,  5 Sep 2024 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGpLgBpO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9004214A8B;
	Thu,  5 Sep 2024 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725546825; cv=none; b=FN/7zoVtjtyTRDLfJUe2bTQJbNkKnTVAosvCirmQRV8w6xcE5Uya/0Uetrdm8xmbSK3Nk5R1s/GDLSR2yuFqwuQy4/r4F2K6+fcN2D2HRJqOrKI/d+wZGpwzba0KVhxDL8k3UoRq5BBVep0rnEKTKMU2bR6xE2Pa3fzPAuuB3UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725546825; c=relaxed/simple;
	bh=ouG7J7a6W/OXFp0P0OuVqloYdpJZkh0tUdoTE+DLK6w=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=n8/TNV/mBsS+JCR36v5sYig7DTQckl0wN1IBb5z5yIqVKzHVti2/AOrFuBhCldsIsBaLiVMXnUJFuKZHZ/yiDNd11TGR2HV30h6rJCl7yMOWc8/2rATe1+R2oBgCEBG7BtEyEyc7L9dIot2Xqxd7LJ4+FrESqT0aLZJKkBpaMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGpLgBpO; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71767ef16b3so573878b3a.0;
        Thu, 05 Sep 2024 07:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725546823; x=1726151623; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cm72bL/68AUbl1iJ0gksulbldlBNiD9PcufDIk9Vjw=;
        b=YGpLgBpOnDjBtlcTYNvb51tr3pL+RyD7NHtfF3chlLf4SDeLkpL7N8SwbUMEnnkDjG
         +IrI63vsuN3ZfgwNLjhs3nVS3+5BrjraRHfmd4igek9wOVSoH45c784eSPG1eUAeAote
         Mb6viEw1r7lcKnXFw9TFlBsHD3SLy6uBQ0IZOjFPQmpoQzUssB4xrc9+/TRvb4gYfIN2
         +bvxtHcfFobUe7u/jTQmrAJRn1Y22NUVNSx1zE/g0UBbOqHugeuEdqg97hVi5FVCM2em
         a6C5wzRfXoCXrmU8VjWSqMPA4IsinA4O6vHeatYPfWMVRCiqlsRbFK3xujbNRV4Wl3+f
         UwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725546823; x=1726151623;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cm72bL/68AUbl1iJ0gksulbldlBNiD9PcufDIk9Vjw=;
        b=jmV/TkO4h+dTx/f3JNHvJxO4A9uwTgIBwcYxJ5Tf3y/end9kRW/MSI9P25NFCIcgGJ
         RHnx3G2Fmxwg4J4D+7Aobyy+Wdae9MYcpr40MmM5sQmuKh2UVBwr3SNFKpUgkPZiyEa3
         kgMd5PQeF3eEiXi73pyOAgG/blP2Gffe3bSeT14HlP/ukzMRhyhWKhj0hvEdX6E1PuQB
         kAGumhd5yxlhsbMLptiqzdl8BwBQLknhiL9ZkWUE1kDnm5O9PH59QuUv8fXnti8B4MmV
         QYZgvA8GYZUwi0X5cFHINGDnIwRIGZXb4JubMoggpk5S+L49QoWJ7Dm3g57G44qBXLDW
         KEjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBRCp5uZ4V4e9v9PmUGKIn5BQqfX3cmj8BrLbxv3nSL39cBr8vbs6FIx/AtBbMI24PHam8jWeMbI+JKNs=@vger.kernel.org, AJvYcCVXn9Xp7nyy/XC8GNun0CjTYWF9sVaJy9bituriL8Q5aGA4KWhQK37Tqo4CkH1gpC2UPJifWHshBO2xQOTr9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKxOH5qXlwHF77jruXxyq1rWY3E5z0TIZqHcrjAWMCQnPbx9fp
	VDXs3nxtOz6Zbk8KQ7QcuS51d58cnu7X+Ev37fht8VP0otOMAYYz
X-Google-Smtp-Source: AGHT+IGBf0w3hnuCngLrUyVzHkc3IWiw9w/RZORyIdNT2hdbie7ledMRQgRsDJwluF9FCOjLA4J6ZA==
X-Received: by 2002:a05:6a21:6b0c:b0:1ce:cf2b:dd23 with SMTP id adf61e73a8af0-1ced6549e15mr15910800637.49.1725546822710;
        Thu, 05 Sep 2024 07:33:42 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717941c50d1sm672193b3a.77.2024.09.05.07.33.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2024 07:33:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 1/2] Introduce klp_ops into klp_func structure
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2409051139540.8559@pobox.suse.cz>
Date: Thu, 5 Sep 2024 22:33:27 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF43117B-DF46-4001-A5D4-49304EFF21AD@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-2-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051139540.8559@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Miroslav
> On Sep 5, 2024, at 18:10, Miroslav Benes <mbenes@suse.cz> wrote:
>=20
> Hi,
>=20
> the subject is missing "livepatch: " prefix and I would prefer =
something=20
> like
>=20
> "livepatch: Move struct klp_ops to struct klp_func"
>=20
> On Wed, 28 Aug 2024, Wardenjohn wrote:
>=20
>> Before introduce feature "using". Klp transition will need an
>> easier way to get klp_ops from klp_func.
>=20
> I think that the patch might make sense on its own as a=20
> cleanup/optimization as Petr suggested. If fixed. See below. Then the=20=

> changelog can be restructured and the above can be removed.
>=20

After the previous discuss, maybe this patch of "livepatch: Move struct =
klp_ops to struct klp_func" is useful, while the second patch need to be =
considered later, right?

> Btw if it comes to it, I would much rather have something like =
"active"=20
> instead of "using".=20
>=20
>> This patch make changes as follows:
>> 1. Move klp_ops into klp_func structure.
>> Rewrite the logic of klp_find_ops and
>> other logic to get klp_ops of a function.
>>=20
>> 2. Move definition of struct klp_ops into
>> include/linux/livepatch.h
>>=20
>> With this changes, we can get klp_ops of a klp_func easily.=20
>> klp_find_ops can also be simple and straightforward. And we=20
>> do not need to maintain one global list for now.
>>=20
>> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
>=20
> Missing "Suggested-by: Petr Mladek <pmladek@suse.com> perhaps?
>=20

Oops, I do miss this message here.

>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 51a258c24ff5..d874aecc817b 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -22,6 +22,25 @@
>> #define KLP_TRANSITION_UNPATCHED        0
>> #define KLP_TRANSITION_PATCHED          1
>>=20
>> +/**
>> + * struct klp_ops - structure for tracking registered ftrace ops =
structs
>> + *
>> + * A single ftrace_ops is shared between all enabled replacement =
functions
>> + * (klp_func structs) which have the same old_func.  This allows the =
switch
>> + * between function versions to happen instantaneously by updating =
the klp_ops
>> + * struct's func_stack list.  The winner is the klp_func at the top =
of the
>> + * func_stack (front of the list).
>> + *
>> + * @node:      node for the global klp_ops list
>> + * @func_stack:        list head for the stack of klp_func's (active =
func is on top)
>> + * @fops:      registered ftrace ops struct
>> + */
>> +struct klp_ops {
>> +       struct list_head node;
>=20
> Not needed anymore.

What is not needed any more, do you means the comment?
>=20
>> +       struct list_head func_stack;
>> +       struct ftrace_ops fops;
>> +};
>> +
>>=20
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 52426665eecc..e4572bf34316 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -760,6 +760,8 @@ static int klp_init_func(struct klp_object *obj, =
struct klp_func *func)
>> if (!func->old_name)
>> return -EINVAL;
>>=20
>> + func->ops =3D NULL;
>> +
>=20
> Any reason why it is not added a couple of lines later alongside the =
rest=20
> of the initialization?

Do you mean I should add couple of lines after 'return -EINVAL' ?

>=20
>> /*
>> * NOPs get the address later. The patched module must be loaded,
>> * see klp_init_object_loaded().
>> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
>> index 90408500e5a3..8ab9c35570f4 100644
>> --- a/kernel/livepatch/patch.c
>> +++ b/kernel/livepatch/patch.c
>> @@ -20,18 +20,25 @@
>> #include "patch.h"
>> #include "transition.h"
>>=20
>> -static LIST_HEAD(klp_ops);
>>=20
>> struct klp_ops *klp_find_ops(void *old_func)
>> {
>> - struct klp_ops *ops;
>> + struct klp_patch *patch;
>> + struct klp_object *obj;
>> struct klp_func *func;
>>=20
>> - list_for_each_entry(ops, &klp_ops, node) {
>> - func =3D list_first_entry(&ops->func_stack, struct klp_func,
>> - stack_node);
>> - if (func->old_func =3D=3D old_func)
>> - return ops;
>> + klp_for_each_patch(patch) {
>> + klp_for_each_object(patch, obj) {
>> + klp_for_each_func(obj, func) {
>> + /*
>> + * Ignore entry where func->ops has not been
>> + * assigned yet. It is most likely the one
>> + * which is about to be created/added.
>> + */
>> + if (func->old_func =3D=3D old_func && func->ops)
>> + return func->ops;
>> + }
>> + }
>> }
>=20
> The function is not used anywhere after this patch.
>=20

Maybe there still other places will call this klp_find_ops? Is it safe =
to delete it?

Regards,
Wardenjohn=

