Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B14145E57
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 23:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVWEK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 17:04:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgAVWEK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 17:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579730648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V/l0W6VcVP5f9MQYDiVbhWAvpRYGH1EkaiyyRHrf+nM=;
        b=BWPPxgkpilWNAG03KcagvneJ0K0NCVs+3FoU/3Ou8PT0NKxC9mxKB/C2lmAiVrBfWsZLgm
        lk6UAP54S1O/3AfVUYyfV0hLPWRt2Q1tfkPvEsbMwDwQ+tyo2/3Rc9lsDZjhp/0OFoIp+g
        w1EBLxLyEUukLabSePVUmM0c6M4K+fY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-vbSaiXmfMbG0UdybIAUWaQ-1; Wed, 22 Jan 2020 17:04:03 -0500
X-MC-Unique: vbSaiXmfMbG0UdybIAUWaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D73561882CCC;
        Wed, 22 Jan 2020 22:04:00 +0000 (UTC)
Received: from treble (ovpn-122-154.rdu2.redhat.com [10.10.122.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D797786450;
        Wed, 22 Jan 2020 22:03:52 +0000 (UTC)
Date:   Wed, 22 Jan 2020 16:03:50 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, mjambor@suse.cz
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20200122220350.zvwyrkip5mvv6j7g@treble>
References: <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
 <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221312030.15957@pobox.suse.cz>
 <alpine.LSU.2.21.2001221556160.15957@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2001221556160.15957@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 22, 2020 at 04:05:27PM +0100, Miroslav Benes wrote:
> I started looking at some btrfs reports and then found out those were 
> already fixed. 
> https://lore.kernel.org/linux-btrfs/cd4091e4-1c04-a880-f239-00bc053f46a2@infradead.org/
> 
> arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_panic()+0x11b: unreachable instruction
> was next...
> 
> Broken code (-fno-ipa-pure-const):
> ...
>     1186:       e8 a5 fe ff ff          callq  1030 <wait_for_panic>
>     118b:       e9 23 ff ff ff          jmpq   10b3 <mce_panic+0x43>
> </end of function>
> 
> Working code (-fipa-pure-const):
>      753:       e8 88 fe ff ff          callq  5e0 <wait_for_panic>
>      758:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
>      75f:       00 
> 
> mce_panic() has:
>                 if (atomic_inc_return(&mce_panicked) > 1)                                                              
>                         wait_for_panic();
>                 barrier();
>                 
>                 bust_spinlocks(1);                                                                                     
> 
> jmpq in the broken code goes to bust_spinlocks(1), because GCC does not 
> know that wait_for_panic() is noreturn... because it is not. 
> wait_for_panic() calls panic() unconditionally in the end, which is 
> noreturn.
> 
> So the question is why ipa-pure-const optimization knows about panic()'s 
> noreturn. The answer is that it is right one of the things the 
> optimization does. It propagates inner noreturns to its callers. (Martin 
> Jambor CCed).
> 
> Marking wait_for_panic() as noreturn (__noreturn), of course, fixes it 
> then. Now I don't know what the right fix should be. Should we mark all 
> these sites as noreturn, or is it ok for the kernel to rely on GCC 
> behaviour in this case? Could we teach objtool to recognize this?

Thanks for looking at it.  I cam to a similar conclusion and I already
had the manual noreturns added (see patch below) before I realized that
-flive-patching was the culprit.

The patch works, but the problem is that more warnings will pop up in
the future and it'll be my job to fix them...

Global noreturns are already a pain today.  There's no way for objtool
to know whether GCC considered a function to be noreturn, we have
already have to keep a hard-coded list of global noreturns in objtool.
It's been a constant source of annoyance and this will add to that.


diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 8d91b0428af1..8a8696b32120 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -192,7 +192,7 @@ static void ttm_bo_add_mem_to_lru(struct ttm_buffer_object *bo,
 	}
 }
 
-static void ttm_bo_ref_bug(struct kref *list_kref)
+static void __noreturn ttm_bo_ref_bug(struct kref *list_kref)
 {
 	BUG();
 }
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 813d46311f6a..2932ecef4dcf 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -945,7 +945,7 @@ extern int	mpt_raid_phys_disk_get_num_paths(MPT_ADAPTER *ioc,
 		u8 phys_disk_num);
 extern int	 mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc);
 extern void	 mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc);
-extern void     mpt_halt_firmware(MPT_ADAPTER *ioc);
+extern void     mpt_halt_firmware(MPT_ADAPTER *ioc) __noreturn;
 
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eb8bd0258360..4db39fef3b56 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -655,7 +655,7 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
 	return prealloc;
 }
 
-static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
+static void __noreturn extent_io_tree_panic(struct extent_io_tree *tree, int err)
 {
 	struct inode *inode = tree->private_data;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d897a8e5e430..b7a94b1739ae 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -321,7 +321,7 @@ static struct rb_node *tree_search(struct rb_root *root, u64 bytenr)
 	return NULL;
 }
 
-static void backref_tree_panic(struct rb_node *rb_node, int errno, u64 bytenr)
+static void __noreturn backref_tree_panic(struct rb_node *rb_node, int errno, u64 bytenr)
 {
 
 	struct btrfs_fs_info *fs_info = NULL;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 18639c069263..3ee230a3dee2 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -175,7 +175,7 @@ extern void __init cred_init(void);
  * check for validity of credentials
  */
 #ifdef CONFIG_DEBUG_CREDENTIALS
-extern void __invalid_creds(const struct cred *, const char *, unsigned);
+extern void __noreturn __invalid_creds(const struct cred *, const char *, unsigned);
 extern void __validate_process_creds(struct task_struct *,
 				     const char *, unsigned);
 
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index f1879884238e..44ca6000b5f1 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -86,7 +86,7 @@ static inline void exit_thread(struct task_struct *tsk)
 {
 }
 #endif
-extern void do_group_exit(int);
+extern void __noreturn do_group_exit(int);
 
 extern void exit_files(struct task_struct *);
 extern void exit_itimers(struct signal_struct *);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 973a71f4bc89..29024c578997 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -98,8 +98,8 @@ EXPORT_SYMBOL(sysctl_max_skb_frags);
  *	Keep out of line to prevent kernel bloat.
  *	__builtin_return_address is not used because it is not always reliable.
  */
-static void skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
-		      const char msg[])
+static void __noreturn
+skb_panic(struct sk_buff *skb, unsigned int sz, void *addr, const char msg[])
 {
 	pr_emerg("%s: text:%p len:%d put:%d head:%p data:%p tail:%#lx end:%#lx dev:%s\n",
 		 msg, addr, skb->len, sz, skb->head, skb->data,
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b6da413bcbd6..ac8807732b10 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -145,6 +145,9 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"machine_real_restart",
 		"rewind_stack_do_exit",
 		"kunit_try_catch_throw",
+		"__invalid_creds",
+		"do_group_exit",
+		"mpt_halt_firmware",
 	};
 
 	if (!func)

