Return-Path: <live-patching+bounces-273-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8E68C93BA
	for <lists+live-patching@lfdr.de>; Sun, 19 May 2024 09:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 826B4281712
	for <lists+live-patching@lfdr.de>; Sun, 19 May 2024 07:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA9B17C6A;
	Sun, 19 May 2024 07:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hkzgk/z+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E2517BA2;
	Sun, 19 May 2024 07:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716104637; cv=none; b=fQKgs5tW8Qz+1OkAusnqGy8U0qPXeifHp3vEMpma7cw9mvHv+9FA6TMQ+2hXLqdWcEaxzSLOUsCToQ+9SuX/DccDbrd0WlipUxAq/PPr9XVZPn1d+jRkGl56fr1NKY6XqAnU4ZtKP9kuik/wauYl9mhb1FpUOuzEj8jfQRMZPbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716104637; c=relaxed/simple;
	bh=BLS/3yqG+x+pmzxow4oCh/ZaClvha66n9SalV6XKyPI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nxgTMr9iF4IRRF+JsHHOHiHGwTCsB+3B8UR9+gVJVcMtZQNc3LughTr2Yxylppr4tfPAZga4z194SsBFx28SMi2Ko+4S8cuyHR/teRt5HoIkWrwyT72JT6it8UZEdpUi6WolC8+HW4rU7PVGzNKAyzY0a+BDZWR+4TAxHu2fdcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hkzgk/z+; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5b27bbcb5f0so867057eaf.3;
        Sun, 19 May 2024 00:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716104635; x=1716709435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sxw0ppvwN68aKsYdrg7i/nk/Ahqb/+wiMV6TU4JTkq0=;
        b=Hkzgk/z+sjGl3uGZ5/cN8u5niBaqdG6cwZ2yYp4ZHzL2Iz5bU/S3D4jgX9Q/gp59x8
         n8c67saLryXiMGxsxNNZV4DJp2V1ORBgQt/fEoyc+h/oe3IRzXIoqaqvPsE2t7YE8+aj
         SRA5sMpKnmSyuE1fwILppZ/JKQw4NyLqoc0VuhoZTVjKR64FjMOYDO7DX3RYZY8C++jj
         KqtdXog21jsNEKQUKXTNWiyH+C7ZGDfBObsC69LzlT4U7cd+4Kw+tAhMBTWbkv2zbwqH
         2WXy4wOHwOqWyKIVWcrSPEOtNZs8mNvA50vSLIewza6Np0t2fwM6ksdRoSX+GEXqBUa0
         858Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716104635; x=1716709435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sxw0ppvwN68aKsYdrg7i/nk/Ahqb/+wiMV6TU4JTkq0=;
        b=sUIMdY8mTNquYl7xrMsM4s9lnE0exBIDOILxDnBbMvURyBA1VD9jIXMZlDBj/1c80R
         fPUOp49Aya32bO9rjUKI4F+0sxuvQgdBZctlA58QONY+/pys110JjojBqq15Fjn+yAud
         mTSIiHMYYQyaJN8HdCncg72/Nuq1I8chIJu+6OSh9DjTenXyAZ6w/WlZor0Yeg92yTH9
         GNiicDhkE/EjlLdI08AxZuoS17EUs7F7eOuwgJvFQCytw5SFLOyFuGQgrzLqh60Edo75
         wghJ7Ee+rmzRXykPpNKeivFgVE7eUNDQZMYyrTN9dxhbjaLpoViF9dP9iesJAPBo/CuS
         lKKA==
X-Forwarded-Encrypted: i=1; AJvYcCV8wSN8xOmg5zj1sczS80lHr1fLo9YTI7tljKE/NW708BRPtcuMc2rybJoXeza9A3skDtTgvXT6e5XHdpegg/RTmmiA+wKoO9bNVxbP
X-Gm-Message-State: AOJu0Yw/s+4mNtnbW7Mb733vGXimdfMFXPkAyJAXkIKlyGuscdixafs3
	nthZqO/qmHOQ2/tvIhD7ph+iTGd4KXiQLNWogTL5/H2gWa+a0csY
X-Google-Smtp-Source: AGHT+IHNm6SmvyxfGJ2bBkTQkzP7Xrbf6qLP88jCweFCOqqbEpA3/8+5OaaoJ+k0I3HpDOHDqyfI/w==
X-Received: by 2002:a05:6358:8093:b0:192:5510:e3ee with SMTP id e5c5f4694b2df-193bb623eb1mr3124570055d.13.1716104635013;
        Sun, 19 May 2024 00:43:55 -0700 (PDT)
Received: from localhost.localdomain ([120.229.27.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b67126b666sm19735722a91.34.2024.05.19.00.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 May 2024 00:43:54 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] livepatch: introduce klp_func called interface
Date: Sun, 19 May 2024 15:43:43 +0800
Message-Id: <20240519074343.5833-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Livepatch module usually used to modify kernel functions.
If the patched function have bug, it may cause serious result
such as kernel crash.

This commit introduce a read only interface of livepatch
sysfs interface. If a livepatch function is called, this
sysfs interface "called" of the patched function will
set to be 1.

/sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called

This value "called" is quite necessary for kernel stability assurance for livepatching
module of a running system. Testing process is important before a livepatch module
apply to a production system. With this interface, testing process can easily
find out which function is successfully called. Any testing process can make sure they
have successfully cover all the patched function that changed with the help of this interface.
---
 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   | 18 ++++++++++++++++++
 kernel/livepatch/patch.c  |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..026431825593 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -37,6 +37,7 @@
  * @nop:        temporary patch to use the original code again; dyn. allocated
  * @patched:	the func has been added to the klp_ops list
  * @transition:	the func is currently being applied or reverted
+ * @called:		the func is called
  *
  * The patched and transition variables define the func's patching state.  When
  * patching, a func is always in one of the following states:
@@ -75,6 +76,7 @@ struct klp_func {
 	bool nop;
 	bool patched;
 	bool transition;
+	bool called;
 };
 
 struct klp_object;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..bc055b56dbe5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -470,6 +470,22 @@ static struct attribute *klp_object_attrs[] = {
 };
 ATTRIBUTE_GROUPS(klp_object);
 
+static ssize_t called_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct klp_func *func;
+	
+	func = container_of(kobj, struct klp_func, kobj);
+	return sysfs_emit(buf, "%d\n", func->called);
+}
+
+static struct kobj_attribute called_kobj_attr = __ATTR_RO(called);
+static struct attribute *klp_func_attrs[] = {
+	&called_kobj_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(klp_func);
+
 static void klp_free_object_dynamic(struct klp_object *obj)
 {
 	kfree(obj->name);
@@ -631,6 +647,7 @@ static void klp_kobj_release_func(struct kobject *kobj)
 static const struct kobj_type klp_ktype_func = {
 	.release = klp_kobj_release_func,
 	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = klp_func_groups,
 };
 
 static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
@@ -903,6 +920,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 static void klp_init_func_early(struct klp_object *obj,
 				struct klp_func *func)
 {
+	func->called = 0;
 	kobject_init(&func->kobj, &klp_ktype_func);
 	list_add_tail(&func->node, &obj->func_list);
 }
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..75b9603a183f 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -118,6 +118,8 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	if (func->nop)
 		goto unlock;
 
+	if (!func->called)
+		func->called = true;
 	ftrace_regs_set_instruction_pointer(fregs, (unsigned long)func->new_func);
 
 unlock:
-- 
2.37.3


