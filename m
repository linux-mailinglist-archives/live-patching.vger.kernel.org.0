Return-Path: <live-patching+bounces-684-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0291986087
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 16:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CD661F23FA6
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 14:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5B11AB6E0;
	Wed, 25 Sep 2024 13:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T3I73COa"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876551AB6D1
	for <live-patching@vger.kernel.org>; Wed, 25 Sep 2024 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727269713; cv=none; b=If/MOJgaelx9AwdogNxY6dRaY3uepvsBBQOL8rTbs3Ccf+V/kgR5N8SEeT9K9HFTPSvcwPImePd6JpWBrv7XAGDsAOIDkkoyP/UGV6Hy4cl017w9WoU9Ij/dtW8pO5i+msqVBb2SwAVBeQBNlm4l3+yVJxzwsy3vnF2bG706N4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727269713; c=relaxed/simple;
	bh=oy4FjmWQhhsk5gZLF9a56ivnKadXTHvPmDY2gbMhqvo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mtTB+kswB2ybQKg4SLP+nBdLTSL9URvZmgjrCMPhw4pXTc8OO1gFN7RHqvubJsfp5ROHrao3CC/M4gsufaf0uSMoJkKk+EloGqKulNVxKZelvZAvGFRe+GOzerUqwwFEhkN1dGLCzqkMAuMIuWSTAWuHPIqrVaKFLiFPgW97I64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T3I73COa; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5365b6bd901so7991924e87.2
        for <live-patching@vger.kernel.org>; Wed, 25 Sep 2024 06:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727269708; x=1727874508; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oy4FjmWQhhsk5gZLF9a56ivnKadXTHvPmDY2gbMhqvo=;
        b=T3I73COapJbJgVYo1UhXp2YVW0gW9rHa9Y72ncJe4xpPvhYIVsqZTU/O7a8u9U9DKj
         xxNFsixKhOamNd3YkkE28zkuyx3QTQmc8DH263s4cjk+1z0u9BVsvAM3ZNyab6LuUpMp
         +/jEm6iVPuAR+TlhMqe8wJ9sX9zGV4WJ97dsR+X1oCp/BI6vcs/pSXpegYkpWybkW12C
         muvbjSBn7M3+A8c+6xTeVaZxD3+Rq0mLDkXJFjSPKIT2ECzKqyOJ/S7p2kV6EnLSwYS1
         cfr3FwgnXYACFUB9DYhUhSxIgAyjb83D2Ce+DR7Ji5CA1PRIPF9nqybNuTKAST3VWqWO
         cVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727269708; x=1727874508;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oy4FjmWQhhsk5gZLF9a56ivnKadXTHvPmDY2gbMhqvo=;
        b=VPGQ7GN33uEVnTbO8SifchYXMwRDROx+3Lg74sckunPwdKXYuwVS8d0Wop5Y+xKFLD
         qFA6uRzGk9uYPgCJmgEyJcMr3rnyqqsKYXpJ9vd8zqoEUhA2WxcYXVa1tggfudEbg41f
         MNUWrDmyqRHoecLFHM773TtP3IRdDIHmrWsg1tFFzg8Qonps9vjIspaqMMpIpmjAlL9/
         J285A4tZbQaLJNvyPBo6D2UqQHiBUwnqTfbpZJoiR8ZIZx+4oqEsuGyLsQbd3+6utxKH
         HRaZGm1prXNZCY2AYxr+KGupx8LmGz1T312iDYtVknwWYBw/zybeWR83bkLEm1ZzSkyZ
         /ywg==
X-Gm-Message-State: AOJu0YzQ9BsF2h7iB7z4AI0fUJdsIVybuqi0p8T80/7sOzQ7n1H2tqJz
	6a1SHE+1tsxZ0bDNzOzCeWOiWeJ8atpCEDn4eY3AEjy2nGrvFci6vm6NgvMx6V4=
X-Google-Smtp-Source: AGHT+IEhmiM9PRXA9kCtpYEyjG2XjauKbi5RYBQYK5ElaZTVJYzszEWccWppxnF9+yJhAmG+NxP6Ig==
X-Received: by 2002:a05:6512:400d:b0:530:ad7d:8957 with SMTP id 2adb3069b0e04-53877564917mr1761043e87.49.1727269708468;
        Wed, 25 Sep 2024 06:08:28 -0700 (PDT)
Received: from [192.168.3.3] (77.39.160.45.gramnet.com.br. [45.160.39.77])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c5cf4c500dsm1797598a12.61.2024.09.25.06.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 06:08:28 -0700 (PDT)
Message-ID: <0fe8f8d36fb5fc78c645b26c20b5ae365bb59991.camel@suse.com>
Subject: Re: [PATCH 0/2] livepatch: introduce 'stack_order' sysfs interface
 to klp_patch
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>, jpoimboe@kernel.org, mbenes@suse.cz,
  jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Sep 2024 10:08:22 -0300
In-Reply-To: <20240925064047.95503-1-zhangwarden@gmail.com>
References: <20240925064047.95503-1-zhangwarden@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-09-25 at 14:40 +0800, Wardenjohn wrote:
> As previous discussion, maintainers think that patch-level sysfs
> interface is the
> only acceptable way to maintain the information of the order that
> klp_patch is=20
> applied to the system.
>=20
> However, the previous patch introduce klp_ops into klp_func is a
> optimization=20
> methods of the patch introducing 'using' feature to klp_func.
>=20
> But now, we don't support 'using' feature to klp_func and make
> 'klp_ops' patch
> not necessary.
>=20
> Therefore, this new version is only introduce the sysfs feature of
> klp_patch=20
> 'stack_order'.

The approach seems ok to me, but I would like to see selftests for this
new attribute. We have been trying to add more and more selftests for
existing known behavior, so IMO adding a new attribute should contain a
new test to exercise the correct behavior.

Other than that, for the series:

 Acked-by: Marcos Paulo de Souza <mpdesouza@suse.com>

>=20
> V1 -> V2:
> 1. According to the suggestion from Petr, to make the meaning more
> clear, rename
> 'order' to 'stack_order'.
> 2. According to the suggestion from Petr and Miroslav, this patch now
> move the=20
> calculating process to stack_order_show function. Adding klp_mutex
> lock protection.
>=20
> Regards.
> Wardenjohn.
>=20


