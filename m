Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C16A4BD80F
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 09:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343790AbiBUIfc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 03:35:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiBUIfb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 03:35:31 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08F2BF5D;
        Mon, 21 Feb 2022 00:35:07 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4K2Fwn6wDpz9sSH;
        Mon, 21 Feb 2022 09:35:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LuaZJkiB-gI2; Mon, 21 Feb 2022 09:35:05 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4K2Fwn63tHz9sSG;
        Mon, 21 Feb 2022 09:35:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BD2788B76E;
        Mon, 21 Feb 2022 09:35:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id bxoRSNtyKq7s; Mon, 21 Feb 2022 09:35:05 +0100 (CET)
Received: from [192.168.7.34] (unknown [192.168.7.34])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C85818B765;
        Mon, 21 Feb 2022 09:35:04 +0100 (CET)
Message-ID: <0ea89614-9bab-99f5-47a8-2a2996c38966@csgroup.eu>
Date:   Mon, 21 Feb 2022 09:35:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v6 09/13] module: Move kallsyms support into a separate
 file
Content-Language: fr-FR
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@redhat.com>, mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, joe@perches.com,
        msuchanek@suse.de, oleksandr@natalenko.name
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-10-atomlin@redhat.com>
 <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu>
In-Reply-To: <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



Le 21/02/2022 à 09:15, Christophe Leroy a écrit :
> 
> 
> Le 18/02/2022 à 22:25, Aaron Tomlin a écrit :
>> No functional change.
>>
>> This patch migrates kallsyms code out of core module
>> code kernel/module/kallsyms.c
>>
>> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> 
> With this patch I get an Oops:
> 
> [   36.421711] BUG: Unable to handle kernel data access on write at 
> 0xbe79bb40
> [   36.428435] Faulting instruction address: 0xc008b74c
> [   36.433342] Oops: Kernel access of bad area, sig: 11 [#1]
> [   36.438672] BE PAGE_SIZE=16K PREEMPT CMPC885
> [   36.442947] SAF3000 DIE NOTIFICATION
> [   36.446421] Modules linked in:
> [   36.449436] CPU: 0 PID: 374 Comm: insmod Not tainted 
> 5.17.0-rc4-s3k-dev-02274-g7d4ec8831803 #1016
> [   36.458211] NIP:  c008b74c LR: c00897ac CTR: c001145c
> [   36.463200] REGS: caf8bcf0 TRAP: 0300   Not tainted 
> (5.17.0-rc4-s3k-dev-02274-g7d4ec8831803)
> [   36.471633] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 24002842  XER: 00000000
> [   36.478261] DAR: be79bb40 DSISR: c2000000
> [   36.478261] GPR00: c00899a0 caf8bdb0 c230a980 be74c000 caf8beb8 
> 00000008 00000000 c035629c
> [   36.478261] GPR08: be75c000 caf9c9fc be79bb40 00000004 24002842 
> 100d166a 00000290 00000000
> [   36.478261] GPR16: c0747320 caf9c9fc c11ff918 caf9b2a7 be75c290 
> 00000550 00000022 c0747210
> [   36.478261] GPR24: c11ff8e8 be74c000 c11ff8fc 100b8820 00000000 
> 00000000 be74c000 caf8beb8
> [   36.516729] NIP [c008b74c] add_kallsyms+0x48/0x30c
> [   36.521465] LR [c00897ac] load_module+0x16f8/0x2504

Fixup:

diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 6c8f1f390cf5..2ee8d2e67068 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -171,8 +171,7 @@ void add_kallsyms(struct module *mod, const struct 
load_info *info)
  	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];

  	/* Set up to point into init section. */
-	mod->kallsyms = (struct mod_kallsyms __rcu *)mod->init_layout.base +
-		info->mod_kallsyms_init_off;
+	mod->kallsyms = (void __rcu *)mod->init_layout.base + 
info->mod_kallsyms_init_off;

  	/* The following is safe since this pointer cannot change */
  	rcu_dereference_sched(mod->kallsyms)->symtab = (void *)symsec->sh_addr;


Christophe
