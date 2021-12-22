Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA2647D052
	for <lists+live-patching@lfdr.de>; Wed, 22 Dec 2021 11:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244280AbhLVKxi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 05:53:38 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:36396 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbhLVKxi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 05:53:38 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0A9BD21119;
        Wed, 22 Dec 2021 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640170417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJ2U1plwpLCOh69jwKH2H2AUnK0retAXhVE/mzoRsM0=;
        b=SJGPjehIxiFmm9bx63yyfH8JnUlwIaEZhbVkGs1IIWyo0pTXiS8cusYq0+TOzO43H3B/59
        W9/NP7d8y+21RTGGj8jsdAFa//udRMriF6mMSQ8rmcXgD3+UkfNCk2GLXFuLrV/XQxzczi
        52qbu39OaKXNfcKXd1/DTLV9cOXegx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640170417;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJ2U1plwpLCOh69jwKH2H2AUnK0retAXhVE/mzoRsM0=;
        b=WaRK979/6hg7fnrh01UuUJmk6MFlsaqunu4H9zrJCjFha/G8Sq5449rbSUmEFKuzW9u/uQ
        mbD4l7HU64OhYGAw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BEFD2A3B92;
        Wed, 22 Dec 2021 10:53:36 +0000 (UTC)
Date:   Wed, 22 Dec 2021 11:53:36 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     David Vernet <void@manifault.com>
cc:     pmladek@suse.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net
Subject: Re: [PATCH v3] Documentation: livepatch: Add livepatch API page
In-Reply-To: <20211221145743.4098360-1-void@manifault.com>
Message-ID: <alpine.LSU.2.21.2112221153070.18494@pobox.suse.cz>
References: <20211221145743.4098360-1-void@manifault.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 21 Dec 2021, David Vernet wrote:

> The livepatch subsystem has several exported functions and objects with
> kerneldoc comments. Though the livepatch documentation contains handwritten
> descriptions of all of these exported functions, they are currently not
> pulled into the docs build using the kernel-doc directive.
> 
> In order to allow readers of the documentation to see the full kerneldoc
> comments in the generated documentation files, this change adds a new
> Documentation/livepatch/api.rst page which contains kernel-doc directives
> to link the kerneldoc comments directly in the documentation.  With this,
> all of the hand-written descriptions of the APIs now cross-reference the
> kerneldoc comments on the new Livepatching APIs page, and running
> ./scripts/find-unused-docs.sh on kernel/livepatch no longer shows any files
> as missing documentation.
> 
> Note that all of the handwritten API descriptions were left alone with the
> exception of Documentation/livepatch/system-state.rst, which was updated to
> allow the cross-referencing to work correctly. The file now follows the
> cross-referencing formatting guidance specified in
> Documentation/doc-guide/kernel-doc.rst. Furthermore, some comments around
> klp_shadow_free_all() were updated to say <_, id> rather than <*, id> to
> match the rest of the file, and to prevent the docs build from emitting an
> "Inline emphasis start-string without end string" error.
> 
> Signed-off-by: David Vernet <void@manifault.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
