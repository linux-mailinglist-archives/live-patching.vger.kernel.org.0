Return-Path: <live-patching+bounces-251-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 218B78BE51A
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 16:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD5232880AA
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 14:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A710D15EFD3;
	Tue,  7 May 2024 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBenVZPR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAA115E5C4;
	Tue,  7 May 2024 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715090678; cv=none; b=kgrY/33OmlPIpe+0VNrgugU33MLQDIe+JKSF9ok1RwlwqyXjoiarEMM0jHzgfuUHdihfjUof1opXhakZW1ZX9eV1gJgZ6NNNi0WLFZ0ItBOU5/teTLqzr/WZahdjWMmIXMUiBRtQUy0jk2A29zeWSO/GW5JL4CDhvgKVflCwxto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715090678; c=relaxed/simple;
	bh=nlaeZmL+KJJ2V177uLxHFZ29IrgSTAq0VC/0/V/HUIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gz1vVumZFnv2PWLabYqqhSIfJsTn4VqNCKCrHn/uQAo+2HOLEpTGyjhsoER+S/vElwaW4JZpmkr3MHIm+TOyYSjwK8dJB5Ufd88juJYxh0Ysq3SkSPXleRTXC61ZM1oKLq2UeiUJANl9kGDr9TLtZoXDz/UGC2oRgU8YnhCS/6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBenVZPR; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6a0ff97a9c7so43040126d6.0;
        Tue, 07 May 2024 07:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715090676; x=1715695476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mBGToCMB6kGQ+VwKBgwLZvBpbX3sGXBJlbKQvazNkag=;
        b=lBenVZPRzznHMARA/cALxRZps3j3WN26eJ0N1bWGsl1S1d0sOLb+yXVHCyYP7kqNij
         tRpZLGrj0qv7R9LbhezbSYLX1N1qEq9gL3KVAm5SsZn+g+xwsYtYvEqCW4oCTcroyFqw
         Ue5Qvmd52D4t7sRSD4hPdW1oylav2YEMEfeSfIRMRUpNz972QMT8BJnvsMfsIU8e2MBf
         ORjJqv+B0GX9vB7qogWf/o3WQnP6//Zw3QFW9vRuTqDsofL5SW1kJrTMj4PacJ5qyU1m
         8VFgFTWakgO1FzmynH+Gi7kgVPbR/I1CGtD/yB0E0J2TnvcrQdn2qVvocdg3ydqozGjt
         i5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715090676; x=1715695476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBGToCMB6kGQ+VwKBgwLZvBpbX3sGXBJlbKQvazNkag=;
        b=suwnvO8NtPg8osKjnRViH9PG60Tk+j9Y0sD1geQpT/gwFBjw3Jd8Q9gDQnTGZFlE0j
         bewckW5xmiI9qS5jNIf7RoDjFce0EiaFamYDeTf9cRu+QbS5OTuRvMRir6hQKNkr08mN
         JE5Dtf9LhQ2R2Tf2dIUyRYA2BalLthZAAGWOfhYdoSEplUDvrdXhDSUAi/z2BSZZTWU0
         +ez5/1LOcMaULp0dBMm1IPOhm70TCkHIZHXLd/VSjDCg3axBhqzinWACvPPJAtKMQbIH
         /9y3h05sgcK4RkC9eFMFLsfpWn/BrPOqIVmGy4VRAvw5AoIAo9Vz+vvj+8cobI6QSSBa
         fehw==
X-Forwarded-Encrypted: i=1; AJvYcCUazzrEK2AX9T6l5V6pC8LYKbu8/74G7ou06UbxwKoY8rEPcg+wTELx5LRVKydWKbCO6YoXx0jMjdm5XxYf9MFGLgxXqfHkYLoWSs3/AyapZbrZDH7IUb+rGKh3mkkqLy0IjDa/vq2I6EBYu3k=
X-Gm-Message-State: AOJu0YyFpQWq63JjlWSldbswng8WYgFO3bUB/ULfMblYQbFsn1oc44jw
	t9IMlo4Zx8xGcapNwGwwxT6m15iCvf0vayOvh77DQdQEaA5yjjWtC/S3spy3Ufxz+WQb+FzTMU7
	3lWlOGmMR+M5mP/UN3vx0T3EeXwQugsBCiKo=
X-Google-Smtp-Source: AGHT+IGiSNwX2oRF7dtfcnU9xHgu+cAheggzUcyFac3OO2PogaW1cgJI/dNFidFeO7Q9jjbP9VElAFgbTMAHVYIAWOw=
X-Received: by 2002:a05:6214:c84:b0:6a0:b3ec:9032 with SMTP id
 r4-20020a0562140c8400b006a0b3ec9032mr4787351qvr.12.1715090675961; Tue, 07 May
 2024 07:04:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407035730.20282-1-laoar.shao@gmail.com> <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble> <Zji_w3dLEKMghMxr@pathway.suse.cz> <20240507023522.zk5xygvpac6gnxkh@treble>
In-Reply-To: <20240507023522.zk5xygvpac6gnxkh@treble>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 May 2024 22:03:59 +0800
Message-ID: <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 7, 2024 at 10:35=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Mon, May 06, 2024 at 01:32:19PM +0200, Petr Mladek wrote:
> > Also it would require adding an API to remove the sysfs files from the
> > module_exit callback.
>
> Could the sysfs removal be triggered from klp_module_going() or a module
> notifier?
>
> > I do not see any reasonable reason to keep the replaced livepatch
> > module loaded. It is an unusable piece of code. IMHO, it would be
> > really convenient if the kernel removed it.
>
> User space needs to be polling for the transition to complete so it can
> reverse the patch if it stalls.  Otherwise the patch could stall forever
> and go unnoticed.
>
> Can't user space just unload the replaced module after it detects the
> completed transition?

Are you referring to polling the
"/sys/kernel/livepatch/XXX/transition"? The challenge lies in the
uncertainty regarding which livepatches will be replaced and how many.
Even if we can poll the transition status, there's no guarantee that a
livepatch will be replaced by this operation.

>
> I'm not sure I see the benefit in complicating the kernel and possibly
> introducing bugs, when unloading the module from user space seems to be
> a perfectly valid option.
>
> Also, an error returned by delete_module() to the kernel would be
> ignored and the module might remain in memory forever without being
> noticed.

As Petr pointed out, we can enhance the functionality by checking the
return value and providing informative error messages. This aligns
with the user experience when deleting a module; if deletion fails,
users have the option to try again. Similarly, if error messages are
displayed, users can manually remove the module if needed.

--=20
Regards
Yafang

