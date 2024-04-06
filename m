Return-Path: <live-patching+bounces-220-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF3889A994
	for <lists+live-patching@lfdr.de>; Sat,  6 Apr 2024 09:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B372F1F21DF8
	for <lists+live-patching@lfdr.de>; Sat,  6 Apr 2024 07:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8186C2110F;
	Sat,  6 Apr 2024 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CthhO1Np"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC035A50;
	Sat,  6 Apr 2024 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712389015; cv=none; b=UPdYzsBAvidUYvabYLuZXW8XV8E1R3yFKfFoZbzBhmAh0lSDrGUMfvfQTKsg8bb2czQ5NYKYsWvSfXZrChhPVNtsZi2EwaOSmtnLr6AZfMTnDaeXpl5ESuqftrBfPz2QQY0L+y9XOR7tM7HZAtV6V1Pk0PRizT98C8mrPvwywdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712389015; c=relaxed/simple;
	bh=tnWZtrVLZ8ZFtrUl8hcXZMfy91BO/KxdivHhQBFCx6g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=O8bhu0XemfUMbcg+Po7+b1ConEnLOnm74Gm+35jr9CYLBjb4N1gAAkErEgkjQk7u9x4U3Tt4eWvrOXoBaGtYb8tet+vOzm28SoV9Va1SvIzTH1SOD4E4TMo5X1AD3m8CF2cwjNNdJmFa4mctqZt8tb+n2onJON+064ZgXy8XmHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CthhO1Np; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e2c725e234so12309805ad.1;
        Sat, 06 Apr 2024 00:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712389013; x=1712993813; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPUo5IF6/IL6HuUeae5PEg4ynGFJ5HzX5Le2AQ5XNN8=;
        b=CthhO1Np3xziCFPVY2htHvuASQs04lZdnlIk9kr+uxjvC3ie1z/Qc/FEpyM11qbqaF
         NQnNptjKkZSd7f/0QObSVuKl7TxDaushNdXDY5ZzZVIUWqkfKJoAdmJFZBHTVjw+Borr
         xaK2DRdhPFVDuOWsQxP1ERz87MduthLaNOS6DMRCFv06eheP2a/8uQDQJb1y9/tpd2d9
         ve7oLzPMfeoSRHK/Px70pYHvKi+P5i36nS6cHLjRkSvJlIDRWgUUEVkzAq2WvwA4Pq6d
         DSyjq8POjKJn/423hYxoQBEInciBMPHCEWc1rPYHxo+n1Aw6a5Ppru39grqHKS+ZA+6y
         SCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712389013; x=1712993813;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPUo5IF6/IL6HuUeae5PEg4ynGFJ5HzX5Le2AQ5XNN8=;
        b=wqKUP2EdoMZxT/d5SQEbYTTsFyNlB2ULhENvpN2z1Ztxcswi0Pc0daTUlYWcR+0iV4
         INpcA/adjJpufABduQGNwhNegifzd/7o+enZrpu89pmgqIUhtelVTvJpgX5ZsgPqkN/w
         T0tcxq+uEmqONCqFwChIl1J7cB+MkyqhN1MbrzrUVL1Q5IWZ6w7rCEr/tw15gPM3PxDp
         6scLbiOkiZa2vBdBW7MJ9+efRlN4RZgjWQeGBLczsUidP2Kh0Q6rGBDfICOWdjO4la8/
         T+BsXuAzOmDLlxt00QHt0Wbl41DlzjvYvwOQQ7aSHq9Z+z+f0lKWVXNrxpu33zw9Y3yL
         dFIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCAehP6BYWKaXd1dqAVluFUuySQM5YA7lI4CbmF3U35ofS/V3QHwu6hjPvHilsr1T20iTrdHKb4xc/yP8mGfZooptJGMckfHIWxZERNBaK2SawFS/47P4W5dFvUp6VDDSeQUipmscgxfmeDA==
X-Gm-Message-State: AOJu0Yxc1L8EsKs9ng+IDNJ+kw61h66zAqYneNNXnXuBbbrLXMTGlzwi
	XJgmWbH/hWNuCowQk1MVO8AtX8K9R7i/yx+fD/gibKbDfkYqnHM+
X-Google-Smtp-Source: AGHT+IEbTxV8PwhsRDGqnn6crmiEmwmZy2zumt3HyWueGp4W2AfNucnvC/9uk//0v9Yxg3iBFtckKA==
X-Received: by 2002:a17:902:cf41:b0:1e2:45f3:2d57 with SMTP id e1-20020a170902cf4100b001e245f32d57mr5622419plg.6.1712389013122;
        Sat, 06 Apr 2024 00:36:53 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id b2-20020a170903228200b001e038619e34sm2804719plh.221.2024.04.06.00.36.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Apr 2024 00:36:52 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] livepatch: Add KLP_IDLE state
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <4506bb59-5524-8b0e-f97c-a0252d4784ad@redhat.com>
Date: Sat, 6 Apr 2024 15:36:37 +0800
Cc: Petr Mladek <pmladek@suse.com>,
 jpoimboe@kernel.org,
 mbenes@suse.cz,
 jikos@kernel.org,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF3BD11E-D4B9-4490-91FC-41066452D32B@gmail.com>
References: <20240402030954.97262-1-zhangwarden@gmail.com>
 <ZgwNn5+/Ryh05OOm@redhat.com> <Zg7EpZol5jB_gHH9@alley>
 <4506bb59-5524-8b0e-f97c-a0252d4784ad@redhat.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)


Hi Joe and Petr :
> On Apr 5, 2024, at 01:50, Joe Lawrence <joe.lawrence@redhat.com> =
wrote:
>=20
> On 4/4/24 11:17, Petr Mladek wrote:
>> On Tue 2024-04-02 09:52:31, Joe Lawrence wrote:
>>> On Tue, Apr 02, 2024 at 11:09:54AM +0800, zhangwarden@gmail.com =
wrote:
>>>> From: Wardenjohn <zhangwarden@gmail.com>
>>>>=20
>>>> In livepatch, using KLP_UNDEFINED is seems to be confused.
>>>> When kernel is ready, livepatch is ready too, which state is
>>>> idle but not undefined. What's more, if one livepatch process
>>>> is finished, the klp state should be idle rather than undefined.
>>>>=20
>>>> Therefore, using KLP_IDLE to replace KLP_UNDEFINED is much better
>>>> in reading and understanding.
>>>> ---
>>>> include/linux/livepatch.h     |  1 +
>>>> kernel/livepatch/patch.c      |  2 +-
>>>> kernel/livepatch/transition.c | 24 ++++++++++++------------
>>>> 3 files changed, 14 insertions(+), 13 deletions(-)
>>>>=20
>>>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>>>> index 9b9b38e89563..c1c53cd5b227 100644
>>>> --- a/include/linux/livepatch.h
>>>> +++ b/include/linux/livepatch.h
>>>> @@ -19,6 +19,7 @@
>>>>=20
>>>> /* task patch states */
>>>> #define KLP_UNDEFINED -1
>>>> +#define KLP_IDLE       -1
>>>=20
>>> Hi Wardenjohn,
>>>=20
>>> Quick question, does this patch intend to:
>>>=20
>>> - Completely replace KLP_UNDEFINED with KLP_IDLE
>>> - Introduce KLP_IDLE as an added, fourth potential state
>>> - Introduce KLP_IDLE as synonym of sorts for KLP_UNDEFINED under =
certain
>>>  conditions
>>>=20
>>> I ask because this patch leaves KLP_UNDEFINED defined and used in =
other
>>> parts of the tree (ie, init/init_task.c), yet KLP_IDLE is added and
>>> continues to use the same -1 enumeration.
>>=20
>> Having two names for the same state adds more harm than good.
>>=20
>> Honestly, neither "task->patch_state =3D=3D KLP_UNDEFINED" nor =
"KLP_IDLE"
>> make much sense.
>>=20
>> The problem is in the variable name. It is not a state of a patch.
>> It is the state of the transition. The right solution would be
>> something like:
>>=20
>>  klp_target_state -> klp_transition_target_state
>>  task->patch_state -> task->klp_transition_state
>>  KLP_UNKNOWN -> KLP_IDLE
>>=20
>=20
> Yes, this is exactly how I think of these when reading the code.  The
> model starts to make a lot more sense once you look at it thru this =
lens :)
>=20

For Joe's questions:
1. I do want to replace KLP_UNDEFINED with KLP_IDLE for livepatch patch =
states are all known instead of undefined.
2. The reason why I tried to make =E2=80=9CKLP_IDLE" state into the same =
value of =E2=80=9CKLP_UNDEFINED" is to make it compatible to =
=E2=80=9CKLP_UNDEFINE"

Since Petr said that this will break some userspace tools, maybe there =
may have a chance to fix it in the future? If you think it bring more =
harm than good.


>> But it would also require renaming:
>>=20
>>  /proc/<pid>/patch_state -> klp_transition_state
>>=20
>> which might break userspace tools =3D> likely not acceptable.
>>=20
>>=20
>> My opinion:
>>=20
>> It would be nice to clean this up but it does not look worth the
>> effort.
>>=20

Maybe we can just fix the code state instead of renaming the proc =
interface?

>=20
> Agreed.  Instead of changing code and the sysfs interface, we could
> still add comments like:
>=20
>  /* task patch transition target states */
>  #define KLP_UNDEFINED   -1      /* idle, no transition in progress */
>  #define KLP_UNPATCHED    0      /* transitioning to unpatched state =
*/
>  #define KLP_PATCHED      1      /* transitioning to patched state */
>=20
>  /* klp transition target state */
>  static int klp_target_state =3D KLP_UNDEFINED;
>=20
>  struct task_struct =3D {
>      .patch_state    =3D KLP_UNDEFINED,   /* klp transition state */
>=20
> Maybe just one comment is enough?  Alternatively, we could elaborate =
in
> Documentation/livepatch/livepatch.rst if it's really confusing.
>=20
> Wardenjohn, since you're probably reading this code with fresh(er) =
eyes,
> would any of the above be helpful?
>=20
> --=20
> Joe

Adding comments will help to understand the code logic. If introducing =
=E2=80=9CKLP_IDLE" is not suitable right now, I am still happy to add =
some comment into the code if you agree.

Best Regards,
Wardenjohn





