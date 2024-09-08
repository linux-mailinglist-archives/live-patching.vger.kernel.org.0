Return-Path: <live-patching+bounces-634-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB409704E8
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 04:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B15B01C2111D
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 02:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC7E19BBA;
	Sun,  8 Sep 2024 02:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7at7MDs"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC5933C5;
	Sun,  8 Sep 2024 02:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725763890; cv=none; b=jdVBA6fyQv9fILaxhxe4LtV8ioqKXhlR14LOZFlGge/YxLx9qOYQWmCiRzAztMiDvOie0yD/z1T2EcAz7EpdW9WrP/rcipBNZlub82pYzC17VlKudb9azKsZWn2CjbKuH678aVDAPRAN1YDM6NYF/xSE6ijKNAtYcAFX1nkXBrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725763890; c=relaxed/simple;
	bh=PC19EQHHckZ7VLKOX/zWu1TH3ZmhRGVbLVBCPb1cazQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MzjFksJDw6lxWBmeHkKgxJBuuVZ2ABsC0yCCzx4cCYUxp+Yq+5GI/dQ52+hZlGYYEMDJcsp7kSu2b7oG9NicdhGyhZromLC5xCVp2bvs4tl6RkIPe+ZQ2+pcnxplpFjxih4K/cYxwi+CxbJrj1A2NsDmcdk+02wjuumbsknuGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7at7MDs; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7c3ebba7fbbso2616786a12.1;
        Sat, 07 Sep 2024 19:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725763889; x=1726368689; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+SrRojYLMRk4wDwyLPgg1lXpOo53TSxFv8f5gEP7IY=;
        b=F7at7MDsD25BqVfMgQslKgaQ4C+J0deSmkKGN91mDq8REc0P56qBMe+PHvSN9F6QAx
         eYYY1sDFgztYM82+ps7m+cQqAWAMYZxeQIN5+AHCb0bqHXiyHWzl0ozW2rKcKaYxntiy
         i5wacCbGuESRp2b4cvgKuPcaZu09+DHsgvJAlkwTyrcwF/nt0EOWExcHAjnpdKak+uAK
         0yuQQZ0z+kuvA4xEctCN7NmCMxfJWgiYXj3UWsku7G7pbxIfOXeX23X/03c8BQ4ECh9u
         6aAonVCi4s8Y8X9CqLdS6V+i/Dnc0/H5iTF+KWoeTHTUVxKAYII/YmdO3G2rF73gXLNM
         l+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725763889; x=1726368689;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+SrRojYLMRk4wDwyLPgg1lXpOo53TSxFv8f5gEP7IY=;
        b=U/tfQfiRoxz/q5N1TNBBHtlepspQ0N09fHoZLV44YeXyYrb/v6B+OgXx0oIjcljGWT
         K6rORyO/avckvqiLGmjO6TF1SRnzchhyjwReZlZh4SxX1Z5sEsuBKO2xYwr0ag9Wx8uz
         fLkxqqEDZI4cPw4U0b9eA+EKvnGqmRNuP+3G8oC9NACumgfG9ekH7j5HtFZt/3qjTAmV
         cAHXf/w48x50P//M4P+3ANK9AI6LzBp/ZX3Fx/TSdS5P/Fzwp6Sc/pCB3WP48LNqYIAa
         Ndcoh/1zusxxtDcboUQCVKt9kTgzrNgiVkY4f+7iOnYcajl03ntehsL6oecgWMbzU2RS
         +w6A==
X-Forwarded-Encrypted: i=1; AJvYcCWcV/0yFG9+3X1WejciADTCMgnZO/MFBfrPPiUkHF3RRlAe9tqkzXgzySyYanIiUWSZTcwZp5AUktxNzoHK5g==@vger.kernel.org, AJvYcCX2EsYiw1lzZCAXZQV8J36JVArw+JsQNsr5H/RR60HYUM2wrXFrnsnIYqbnb9FYLZwa/yNEo3MIHbwoY8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyUUQDhU+cPbwiZq2JL/WGbXMxBWQ6YEDje7ck8ZAbT2p9CCHK
	LZPvnYD3Vd1Kv72FQH15cooEPEH2AmRFOpylwKXEcpGhu9p4RXcdE3jyHHRe9E0=
X-Google-Smtp-Source: AGHT+IGZUM4Qg6dfdgj34NsClLbtcB2Jd1cHlugRVBl66oYhy7CMqLW1kzi16Pl53AQlPXYgVZtD1A==
X-Received: by 2002:a17:902:e805:b0:206:c798:3cd8 with SMTP id d9443c01a7336-206f0624258mr88222585ad.54.1725763888781;
        Sat, 07 Sep 2024 19:51:28 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e0ec71sm14158185ad.25.2024.09.07.19.51.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2024 19:51:28 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZtsqLiJPy5e70Ows@pathway.suse.cz>
Date: Sun, 8 Sep 2024 10:51:14 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B250EB77-AFB0-4D32-BA4E-3B96976F8A82@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
 <ZtsqLiJPy5e70Ows@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Petr
>=20
> The 1st patch adds the pointer to struct klp_ops into struct
> klp_func. We might check the state a similar way as =
klp_ftrace_handler().
>=20
> I had something like this in mind when I suggested to move the =
pointer:
>=20
> static ssize_t using_show(struct kobject *kobj,
> struct kobj_attribute *attr, char *buf)
> {
> struct klp_func *func, *using_func;
> struct klp_ops *ops;
> int using;
>=20
> func =3D container_of(kobj, struct klp_func, kobj);
>=20
> rcu_read_lock();
>=20
> if (func->transition) {
> using =3D -1;
> goto out;
> }
>=20
> # FIXME: This requires releasing struct klp_ops via call_rcu()
> ops =3D func->ops;
> if (!ops) {
> using =3D 0;
> goto out;
> }
>=20
> using_func =3D list_first_or_null_rcu(&ops->func_stack,
> struct klp_func, stack_node);
> if (func =3D=3D using_func)
> using =3D 1;
> else
> using =3D 0;
>=20
> out:
> rcu_read_unlock();
>=20
> return sysfs_emit(buf, "%d\n", func->using);
> }

Bravo, I also have something like this in mind when Miroslav suggested =
to implement the logic in using_show.=20

>=20
> It is racy and tricky. We probably should add some memory barriers.
> And maybe even the ordering of reads should be different.
>=20
> We could not take klp_mutex because it might cause a deadlock when
> the sysfs file gets removed. kobject_put(&func->kobj) is called
> by __klp_free_funcs() under klp_mutex.
>=20
> It would be easier if we could take klp_mutex. But it would require
> decrementing the kobject refcout without of klp_mutex. It might
> be complicated.
>=20
> I am afraid that this approach is not worth the effort and
> is is not the way to go.
>=20

But I don't think I've thought as deeply as you do and may not have =
considered the possible risks. Therefore, I do need your help to make my =
patch perfect.  ^_^

Thank you.
Wardenjohn.=

