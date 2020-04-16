Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A81ACB43
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2020 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894818AbgDPPpd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Apr 2020 11:45:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408694AbgDPPpX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Apr 2020 11:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587051921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+utDsScgznwxfIms0Xj6ZFYVx2OkbDAV0iH3XU6eMzc=;
        b=P4FfGpV9KoJWTBLUa83MfRsVG9iEO3pGscxglTwXzV9GX//TvPS053rVz3IY+1+dAw3sMt
        74JDWASVvK7dEv63/Z+/ohC7pNItU7nEqX87GJQ5pRC6tw82ZqcKXrtZv4VwAbmM6iPPyx
        e/hM6AYDrNOfqQSZ+PTC5u7OQKdyg3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-FQtd2CPSM-iv5pZfWUtpgg-1; Thu, 16 Apr 2020 11:45:18 -0400
X-MC-Unique: FQtd2CPSM-iv5pZfWUtpgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED02C107ACC9;
        Thu, 16 Apr 2020 15:45:16 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D0647E7D4;
        Thu, 16 Apr 2020 15:45:16 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:45:14 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200416154514.xqqyvdtm6hjynbx2@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
 <20200414190814.glra2gceqgy34iyx@treble>
 <20200415142415.GH20730@hirez.programming.kicks-ass.net>
 <20200415161706.3tw5o4se2cakxmql@treble>
 <20200416153131.GC6164@linux-8ccs.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200416153131.GC6164@linux-8ccs.fritz.box>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 16, 2020 at 05:31:31PM +0200, Jessica Yu wrote:
> > But I still not a fan of the fact that COMING has two different
> > "states".  For example, after your patch, when apply_relocate_add() is
> > called from klp_module_coming(), it can use memcpy(), but when called
> > from klp module init() it has to use text poke.  But both are COMING so
> > there's no way to look at the module state to know which can be used.
> 
> This is a good observation, thanks for bringing it up. I agree that we
> should strive to be consistent with what the module states mean. In my
> head, I think it is easiest to assume/establish the following meanings
> for each module state:
> 
> MODULE_STATE_UNFORMED - no protections. relocations, alternatives,
> ftrace module initialization, etc. any other text modifications are
> in the process of being applied. Direct writes are permissible.
> 
> MODULE_STATE_COMING - module fully formed, text modifications are
> done, protections applied, module is ready to execute init or is
> executing init.
> 
> I wonder if we could enforce the meaning of these two states more
> consistently without needing to add another module state.
> 
> Regarding Peter's patches, with the set_all_modules_text_*() api gone,
> and ftrace reliance on MODULE_STATE_COMING gone (I think?), is there
> anything preventing ftrace_module_init+enable from being called
> earlier (i.e., before complete_formation()) while the module is
> unformed? Then you don't have to move module_enable_ro/nx later and we
> keep the MODULE_STATE_COMING semantics. And if we're enforcing the
> above module state meanings, I would also be OK with moving jump_label
> and static_call out of the coming notifier chain and making them
> explicit calls while the module is still writable.
> 
> Sorry in advance if I missed anything above, I'm still trying to wrap
> my head around which callers need what module state and what module
> permissions :/

Sounds reasonable to me...

BTW, instead of hard-coding the jump-label/static-call/ftrace calls, we
could instead call notifiers with MODULE_STATE_UNFORMED.

-- 
Josh

