Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A805481723
	for <lists+live-patching@lfdr.de>; Wed, 29 Dec 2021 22:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhL2V47 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Dec 2021 16:56:59 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:34541 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhL2V47 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Dec 2021 16:56:59 -0500
Received: by mail-qt1-f172.google.com with SMTP id o17so20116985qtk.1;
        Wed, 29 Dec 2021 13:56:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5T8nM04UC1tJr9rLxDUzayx806Y7vEpOmH00QoWqw4s=;
        b=6YwqugI8A6JISgkj4Uje6kvOdC5/yNQT9q2Dg+/6Pg1P0YcW4Qv1FHta5l1TEAcaw1
         4MOOKyHnpjdpE0tNABrX25Td7UWlGlObN5TbN3Vlvwmw/mRnWhidqzrM1Z3akUtLiXIE
         3XlMK97LL5W/eIdxy2BlBoLyDjg1rwOoJRvz+0/c4U3xdzAHRqwsVU/kWegoXk2lWAVA
         bGDsRJ6wuYxyFS1OCfexV4RnggY8EAR1X30D3y71B8I1P1ct6Gnc7Q9e5QTfbCgikjEo
         +I/G9ARE2YWbtnBmzJiYdwTEdGy9tpiJXPN/6+p2E+YBBK128DJuZ2rdTmRFhiGyn64F
         hWhw==
X-Gm-Message-State: AOAM530jqLjfM0jDTYbtFa1Km2OdVuRrCifKEIQ5pU5QtThzgiAvMYu7
        eMLsohEhsgAeBKKb8ltXU8SqJahaTM9caQ==
X-Google-Smtp-Source: ABdhPJzIFAMMUfv/7rlsD5mtWAVj+igNbAhJ2sAwKrwq8sZ0PIh3cGjeWtJg7I2+EiYFROTNoid8Og==
X-Received: by 2002:ac8:5c49:: with SMTP id j9mr24727466qtj.253.1640815018130;
        Wed, 29 Dec 2021 13:56:58 -0800 (PST)
Received: from localhost (fwdproxy-ash-116.fbsv.net. [2a03:2880:20ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id j13sm14351758qta.76.2021.12.29.13.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 13:56:57 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com
Cc:     void@manifault.com
Subject: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Date:   Wed, 29 Dec 2021 13:56:47 -0800
Message-Id: <20211229215646.830451-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When initializing a 'struct klp_object' in klp_init_object_loaded(), and
performing relocations in klp_resolve_symbols(), klp_find_object_symbol()
is invoked to look up the address of a symbol in an already-loaded module
(or vmlinux). This, in turn, calls kallsyms_on_each_symbol() or
module_kallsyms_on_each_symbol() to find the address of the symbol that is
being patched.

It turns out that symbol lookups often take up the most CPU time when
enabling and disabling a patch, and may hog the CPU and cause other tasks
on that CPU's runqueue to starve -- even in paths where interrupts are
enabled.  For example, under certain workloads, enabling a KLP patch with
many objects or functions may cause ksoftirqd to be starved, and thus for
interrupts to be backlogged and delayed. This may end up causing TCP
retransmits on the host where the KLP patch is being applied, and in
general, may cause any interrupts serviced by softirqd to be delayed while
the patch is being applied.

So as to ensure that kallsyms_on_each_symbol() does not end up hogging the
CPU, this patch adds a call to cond_resched() in kallsyms_on_each_symbol()
and module_kallsyms_on_each_symbol(), which are invoked when doing a symbol
lookup in vmlinux and a module respectively.  Without this patch, if a
live-patch is applied on a 36-core Intel host with heavy TCP traffic, a
~10x spike is observed in TCP retransmits while the patch is being applied.
Additionally, collecting sched events with perf indicates that ksoftirqd is
awakened ~1.3 seconds before it's eventually scheduled.  With the patch, no
increase in TCP retransmit events is observed, and ksoftirqd is scheduled
shortly after it's awakened.

Signed-off-by: David Vernet <void@manifault.com>
---
 kernel/kallsyms.c | 1 +
 kernel/module.c   | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 0ba87982d017..2a9afe484aec 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -223,6 +223,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 		ret = fn(data, namebuf, NULL, kallsyms_sym_address(i));
 		if (ret != 0)
 			return ret;
+		cond_resched();
 	}
 	return 0;
 }
diff --git a/kernel/module.c b/kernel/module.c
index 40ec9a030eec..c96160f7f3f5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4462,6 +4462,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 				 mod, kallsyms_symbol_value(sym));
 			if (ret != 0)
 				goto out;
+
+			cond_resched();
 		}
 	}
 out:
-- 
2.30.2

