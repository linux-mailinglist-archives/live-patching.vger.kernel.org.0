Return-Path: <live-patching+bounces-1259-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF932A55E17
	for <lists+live-patching@lfdr.de>; Fri,  7 Mar 2025 04:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D14577A308E
	for <lists+live-patching@lfdr.de>; Fri,  7 Mar 2025 03:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BE4189B91;
	Fri,  7 Mar 2025 03:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgJ2oVAc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11515E5AE
	for <live-patching@vger.kernel.org>; Fri,  7 Mar 2025 03:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741317155; cv=none; b=Z2xCJ5MAjpFQzdWpqDXeNkrRALpcGHvNRv9yPueLxuouznt+WHiAoaG5Jtak3BsrjPR3F8YWnr3+DGD2sgpCaq4ztTzSHSeX3ZKu7D4zFlrN15cIZJXOGVU4eFLt9o//pzTayyCfSsgqO5zDngKpB8KEyNncDVAN6sOs5fZ47G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741317155; c=relaxed/simple;
	bh=lyQAEIV5kJ4YMegYa8s7u1TzZvW+Ug54LNXtalREmCg=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=eCdW/iGJHB3i7aXTK0B9hbE0ej9go76F+4IyO3Ci8bdr14m74af2Ftj5G302hhwvNMgnQmAy6ZoqDeAAZmWTJix5Ig7bzDPQ0GNAWbyq4vjYtl4fBF4BgyAxkMO+AehBY7VgTc4C/UJbcv5n2BWM+RxFierlmYGtKHfrT8X5DQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgJ2oVAc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22185cddbffso48479965ad.1
        for <live-patching@vger.kernel.org>; Thu, 06 Mar 2025 19:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741317153; x=1741921953; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ENfxJFyc5Vmv3zuSp7sd2vFcQcmmpoSkW3VI5RdrVyw=;
        b=dgJ2oVAcM/QJp8+Fi7XJHU1AJ3CqfhsaoPNTayiONh6iBFVFp+WpgUYYSYO/yQusiU
         eU4dYoTe5XGYQujPKmZKkZEVJlblBhsHRVeMaFSdpVjaCXwVCtEFuANfTjNLOf0T3WmK
         0oivqXYkKc9WrO3pMauVjf73AOc+BI8elKYGRAxzda6QtTAosYJypqkEkTHKE8haHBZu
         lZOoHbnKdbEpDMt2c1p5OVa77/jvfM1DNHr0GJOS3U5YSFOtY54YgH9nCP3bAEIVk3cA
         z+KEmbg/NmBbMEvBMHWpEd8Uob3Hk+QFYJb5w5UzL740o3d4f6ZYJouNOgw8Yu9eZpCE
         0Ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741317153; x=1741921953;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENfxJFyc5Vmv3zuSp7sd2vFcQcmmpoSkW3VI5RdrVyw=;
        b=YnCS5wXqT/4uLAhs4LAXrB0vOrinFAK6xyjUNOeHgjaQfqEfTVeMF6J1m6Hqm6qUxh
         TV6Cj/DHwnfivbKh/HmK5YXyWiRX0h22RiZUJ/QUzc4PU26qnmqoBnJ8ckhanzNso0wC
         vHjnItlVOxNVvGles16S56Lz0u4ickNvaHoobzOf9w/IKk9g1uIQHIhUe5uS5EpdUpNP
         3W6+v2TWYp9uJH82+t3ViFGTNlOMqGt0V2dCOC27uAKQa6EsYrjBVpWItglLd/+IAWvg
         vcML0OiIyX8owvhh/3dXRrW2IXoXOz3Y8ObyoTzEsNhKe6peFJLO6yqE73xGe+KFCBMR
         6RlA==
X-Forwarded-Encrypted: i=1; AJvYcCUzZh5ySl7vlufAssmDsmR2Rt+TnhWonOzkC2rJVwXxK+5gir3/d9vZtgcqBEcxbQ9nqqrnHeoN7nzV1aSf@vger.kernel.org
X-Gm-Message-State: AOJu0YxxwgkpVpqn+OH9SbjGtrPB1LqBB+waZR921zJvGtRVo7paFxAQ
	kbdNtNFKdX96/2cdkOceEG6sk0PdYMv6J3C0dRz3D/hLUW0g7GKL
X-Gm-Gg: ASbGnctzFqQMZQdZSfYIDsElhl32W+zLVo3Wf8eVvD8qwcJTRHh0E2TXss2S9+z2ZJw
	6JUZP8bum8gMX7oWX9h3Wx4zvBiWeo0les2jyu5bVr4ac/iK17EAEDOU9wnDp8kJajqvVpbpAXV
	cdOkcglYQweLZ63pRovJcsILH7vUu7rFrwCL3gg7epf94ofGOkBqx4VBLa5EupTVW++Gxt6Y7KF
	RZxXGGZNLkR5DUtmmk9yIcacNNCZu1CxfjfdUMhQ3xD4+J6+cX2ImzVroKnxs96D06qMd/evFWX
	hC+znJjuAA4bc/AmRHQnHWYzGA7pyt1dwA9xtYZ6i9uX4CQCUNVGRycCnfGXpiIDwA==
X-Google-Smtp-Source: AGHT+IFPkw3K8rsf7CbGJ+bQFzWwGJbO62d385hupgTucN4leInVgFIVCJ1X5aoMgwhcbYEvQwdCPA==
X-Received: by 2002:a17:903:19e8:b0:224:7a4:b31 with SMTP id d9443c01a7336-22426fd7caamr31073405ad.6.1741317152911;
        Thu, 06 Mar 2025 19:12:32 -0800 (PST)
Received: from smtpclient.apple ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddfddsm19949525ad.2.2025.03.06.19.12.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Mar 2025 19:12:32 -0800 (PST)
From: zhang warden <zhangwarden@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: [RFC] Add target module check before livepatch module loading
Message-Id: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
Date: Fri, 7 Mar 2025 11:12:18 +0800
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org
X-Mailer: Apple Mail (2.3774.500.171.1.1)

I had faced a scenario like this:

There is a fuse.ko which is built as module of kernel source.
However, our team maintain the fuse as oot module.

There is a bug of (name it as B1) the original fuse.ko.=20
And our team fix B1 of fuse.ko as release it as oot module fuse_o1.ko.
Our system loaded fuse_o1.ko. Now, another team made a livepatch module =
base on fuse.ko to fix B2 bug.
They load this livepatch_fuse.ko to the system, it fixed B2 bug, =
however, the livepatch_fuse.ko revert the fix of fuse_o1.ko.

It expose the B1 bug which is already fix in fuse_o1.ko
The exposed B1 bug make fault to our cluster, which is a bad thing :(

This  scenario shows the vulnerable of live-patching when handling=20
out-of-tree module.

I have a original solution to handle this:
    =E2=80=A2 In kpatch-build, we would record the patched object, take =
the object of ko as a list of parameters.
    =E2=80=A2 Pass this ko list as parameter to create-klp-moudle.c
    =E2=80=A2 For each patched ko object, we should read its srcversion =
from the original module. If we use --oot-module, we would read the =
srcversion from the oot moudle version.
    =E2=80=A2 Store the target srcversion to a section named =
'.klp.target_srcversions'
    =E2=80=A2 When the kpatch module loading, we shoud check if section =
'.klp.target_srcversion' existed. If existed, we should check srcversion =
of the patch target in the system match our recorded srcversion or not. =
If thet are not match, refuse to load it. This can make sure the =
livepatch module would not load the wrong target.
This function can avoid livepatch from patching the wrong version of the =
function.

The original discussion can be seem on [1]. (Discussion with Joe =
Lawrence)

After the discussion, we think that the actual enforcement of this seems =
like a job for kernel/livepatch/core.c.
Or it should be the process of sys call `init_module` when loading a =
module.

I am here waiting for Request For Comment. Before I do codes.

Thanks~~ ;)
Wardenjohn.

[1]: https://github.com/dynup/kpatch/issues/1435=

