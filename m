Return-Path: <live-patching+bounces-518-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1639F960781
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63C70B20837
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 10:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C0519E7E5;
	Tue, 27 Aug 2024 10:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ww5ZNZD1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B40C182B2
	for <live-patching@vger.kernel.org>; Tue, 27 Aug 2024 10:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724754735; cv=none; b=ek+tc8HkHWkzSQmHG5Hfiy18c9jjHegOmhSwu5iVPB5qa7xMEFzY7zuHeEC0Uyp7jx4roYEazM4AHj/rWK851Eag/pdZJWfLSWYA6DQq0azA5XFqoVsaMalbrjDK2iDUtXxByOAk8I1EX9UvCDv7139M1y9QeQ6N64ib4azEOu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724754735; c=relaxed/simple;
	bh=ycrqlgO0UTaac+TLC39GdKqmUunZOnZ9hoUmX+4T+CA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gD0enhmBapybtryYzpjE4/F4aIu5tfARS7gNO5xCYPEJtrmPWIOewklJT2z8fJIbdJM98x36cxz1LSUQO3LexJ+yUR/4PGqslOZI78u56cAXII0ezM3abeGmoU0HC+Ntwxmcga/zxSnwRXePwMRCG1lwbhpf+yEsP7Cgga4OZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ww5ZNZD1; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a83562f9be9so477829566b.0
        for <live-patching@vger.kernel.org>; Tue, 27 Aug 2024 03:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724754730; x=1725359530; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7DHuM/kQ41x/auDnPgxPJbUmKbon56f9GOtmDAVesmw=;
        b=Ww5ZNZD1wh8cHxWbYc2DxpxaVV8iDwTiTUzgWkoyEVdvQmSI1CXV8WxRyoCAmQ6QHo
         4qKlNGfTuZ48dnpmOHKZTpBa+7wojGZNzHaVYbpOdIofdjIP45eobB/EXZvkB0l2qdN1
         khRvWcXYNLJ8XqwjHTkPiu2/HZqHgSHPVGVacQxQDtRyazquJRwl0HZBsl9iCxdTKp85
         HvLwkIOQo1dut3zRkCiZadgvQxrJmtU0rf+b1vcnm88hOwwsnb8pjGBdgrzd1ZeD59sl
         /7+qrhJ1uehS8tv5j1c3rLTGN+rk1MfnS9iw3d4mc/QgkdF+mWuPvtJ/gfZvID6teJ9N
         tFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724754730; x=1725359530;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7DHuM/kQ41x/auDnPgxPJbUmKbon56f9GOtmDAVesmw=;
        b=fAXE4NeAYPKOzL8Somd3R8j1YOgPqakFfziIdHxxvQN6xmo+2plrUQWgazhNxfXaNz
         mRLOrxxdFp9r393Q7Am3oc+yXYZNY5g/pkOfPlQq7dqOEyKz4pGm72oHP/P0kmcOj0mc
         Rpk4R2wkaB3z98b5hEU6WEeH48Vepwc3CJlz+YQp7l83gkrEvUWZkoMCXx75myZd8EL6
         girBZMXMryw69orUdVC482BqHtMfav/pKbe0ReYXbqKmca/++yJelfd/tsfIUCdzpHrt
         IWuI2RYlf/HHsMcd2QdYA0xjXd2tlFXcWVziZFdIVGcLIH0DHglgIJBDe8GozEyBvwJR
         lHFA==
X-Forwarded-Encrypted: i=1; AJvYcCVMXisg2490gYtYzbwwcHARkMoA8lCoxIRAyPN8D5J2gWLwTafBLpTLpfCwp8Gg+fUw2UHCEmsnG7UnwXXz@vger.kernel.org
X-Gm-Message-State: AOJu0YxDQeUjTdp8ey8CysicHR47FSE45Q47JNnyv8rSnLiRjd5U81gL
	lwHuT5ZIjemhNA+BgNn4n1QZRrQcNxewbo3uTl1NyQjssA69eSZepB3vZ5iDRw1R0TG5/aU6x/r
	z
X-Google-Smtp-Source: AGHT+IE6qWQu07aKfg9p33jCpIQAbmfOvhptok+ElZDeBxLPmDXF9+w33X0d3/Ez5qHSNqq4vjllpQ==
X-Received: by 2002:a17:907:3da0:b0:a86:817e:d27b with SMTP id a640c23a62f3a-a86a54b05f3mr915301866b.43.1724754730362;
        Tue, 27 Aug 2024 03:32:10 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e588adf2sm92890766b.173.2024.08.27.03.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 03:32:10 -0700 (PDT)
Date: Tue, 27 Aug 2024 12:32:08 +0200
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching selftest fixup for 6.11-rc6
Message-ID: <Zs2rKFzj-EhYoHa3@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

please pull a regression fix in livepatching selftests from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.11-rc6

===================================================

- Fix a regression in a livepatching selftest.

----------------------------------------------------------------
Ryan Sullivan (1):
      selftests/livepatch: wait for atomic replace to occur

 tools/testing/selftests/livepatch/test-livepatch.sh | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

